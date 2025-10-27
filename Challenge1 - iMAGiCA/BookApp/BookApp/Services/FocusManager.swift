//
//  FocusManager.swift
//  BookApp
//
//  Created by Alessandro Cacace on 19/10/25.
//

import Foundation
import FamilyControls
import DeviceActivity
import ManagedSettings
import SwiftUI
import Combine


// This is the brain that manages focus sessions.
// Make it an ObservableObject to use it easily with SwiftUI.
class FocusManager: ObservableObject {
    static let shared = FocusManager()
    
    private let appGroupName = "group.caioagralemos.com"
    private let userDefaultsKey = "focusAppSelection"
    private let activityName = DeviceActivityName("com.BookApp.focus-session")
    private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("BookAppFocusStore"))
    @Published var activitySelection = FamilyActivitySelection() {
        didSet {
            saveSelection()
        }
    }
    
    // Request user permission. Must be called before doing anything else.
    func requestAuthorization() {
        print("🔐 Requesting authorization...")
        // Use `Task` to execute it asynchronously.
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                print("✅ Authorization granted!")
                
                // After getting authorization, try to load saved selection
                DispatchQueue.main.async {
                    self.loadSelection()
                }
            } catch {
                // Handle the error (e.g., user denied permission).
                print("❌ Authorization failed: \(error)")
            }
        }
    }
    
    private func loadSelection() {
        let defaults = UserDefaults(suiteName: appGroupName)
        let decoder = JSONDecoder()
        
        guard let data = defaults?.data(forKey: userDefaultsKey) else {
            print("📂 No saved selection found.")
            return
        }
        
        if let savedSelection = try? decoder.decode(FamilyActivitySelection.self, from: data) {
            self.activitySelection = savedSelection
            print("📱 Loaded \(savedSelection.applicationTokens.count) apps from saved selection.")
        } else {
            print("❌ Failed to decode saved selection.")
        }
    }
    
    private func saveSelection() {
        let defaults = UserDefaults(suiteName: appGroupName)
        let encoder = JSONEncoder()
        
        guard let defaults = defaults else {
            print("❌ Failed to access App Group: \(appGroupName)")
            return
        }
        
        print("💾 Saving selection:")
        print("📱 Individual apps: \(activitySelection.applicationTokens.count)")
        print("📂 Categories: \(activitySelection.categoryTokens.count)")
        print("🌐 Web domains: \(activitySelection.webDomainTokens.count)")
        
        if let encoded = try? encoder.encode(activitySelection) {
            defaults.setValue(encoded, forKey: userDefaultsKey)
            defaults.synchronize()
            print("✅ Selection saved successfully!")
        } else {
            print("❌ Failed to encode selection")
        }
    }
    
    // Apply restrictions to block selected apps
    private func applyRestrictions() {
        print("🛡️ Applying restrictions...")
        print("📱 Apps to block: \(activitySelection.applicationTokens.count)")
        print("📂 Categories to block: \(activitySelection.categoryTokens.count)")
        print("🌐 Web domains to block: \(activitySelection.webDomainTokens.count)")
        
        // Block selected applications
        if !activitySelection.applicationTokens.isEmpty {
            store.shield.applications = activitySelection.applicationTokens
            print("🔒 \(activitySelection.applicationTokens.count) individual apps blocked")
            
            // Force synchronization
            store.shield.applications = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.store.shield.applications = self.activitySelection.applicationTokens
                print("🔄 Restrictions reapplied")
            }
        }
        
        // Block categories if any were selected
        if !activitySelection.categoryTokens.isEmpty {
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(
                activitySelection.categoryTokens
            )
            print("🔒 Categories blocked")
        }
        
        // Block web domains if any were selected
        if !activitySelection.webDomainTokens.isEmpty {
            store.shield.webDomains = activitySelection.webDomainTokens
            print("🔒 Web domains blocked")
        }
        
        print("✅ Restrictions applied successfully!")
    }
    
    // Remove all restrictions
    private func removeRestrictions() {
        print("🔓 Removing all restrictions...")
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        print("✅ All restrictions removed.")
    }
    
    func startFocusSession(durationInMinutes: Int) {
        print("🚀 Trying to start focus session...")
        print("📱 Selected apps: \(activitySelection.applicationTokens.count)")
        print("🔐 Authorization status: \(AuthorizationCenter.shared.authorizationStatus)")
        
        // Check authorization status
        guard AuthorizationCenter.shared.authorizationStatus == .approved else {
            print("❌ Authorization not granted! Status: \(AuthorizationCenter.shared.authorizationStatus)")
            return
        }
        
        // Check if user has selected any apps or categories
        let hasApps = !activitySelection.applicationTokens.isEmpty
        let hasCategories = !activitySelection.categoryTokens.isEmpty
        let hasWebDomains = !activitySelection.webDomainTokens.isEmpty
        
        guard hasApps || hasCategories || hasWebDomains else {
            print("⚠️ No selection found! Select apps, categories or domains to block.")
            return
        }
        
        // Apply restrictions immediately
        applyRestrictions()
        
        // For short sessions (less than 5 minutes), use only ManagedSettings
        // For long sessions, also use DeviceActivity
        if durationInMinutes >= 5 {
            // Define the time interval (minimum 1 minute for DeviceActivity)
            let actualDuration = max(durationInMinutes, 1)
            print("⏰ Duration: \(actualDuration) minutes - using DeviceActivity")
            
            let calendar = Calendar.current
            let now = Date()
            let endDate = now.addingTimeInterval(TimeInterval(actualDuration * 60))
            let startComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
            let endComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: endDate)
               
            let schedule = DeviceActivitySchedule(
                intervalStart: startComponents,
                intervalEnd: endComponents,
                repeats: false
            )
            
            let durationComponents = DateComponents(minute: actualDuration)
            
            // Define an event with information the extension can receive
            let event = DeviceActivityEvent(
                applications: activitySelection.applicationTokens,
                threshold: durationComponents
            )
            
            // Start the activity
            let eventName = DeviceActivityEvent.Name("com.BookApp.focus-event.duration")
            let eventsDictionary: [DeviceActivityEvent.Name : DeviceActivityEvent] = [
                eventName: event
            ]

            let center = DeviceActivityCenter()
            do {
                try center.startMonitoring(activityName, during: schedule, events: eventsDictionary)
                print("✅ DeviceActivity started for \(actualDuration) minutes.")
            } catch {
                print("⚠️ DeviceActivity failed: \(error)")
                print("🔄 Continuing with ManagedSettings only...")
            }
        } else {
            print("⏰ Duration: \(durationInMinutes) minutes - using ManagedSettings only")
        }
        
        print("✅ Focus session started!")
        print("📱 Blocking \(activitySelection.applicationTokens.count) apps + \(activitySelection.categoryTokens.count) categories.")
    }
    
    // Function to STOP the session manually
    func stopFocusSession() {
        // Stop monitoring the activity
        DeviceActivityCenter().stopMonitoring([activityName])
        
        // Remove all app restrictions
        removeRestrictions()
        
        print("🛑 Focus session stopped.")
    }
}
