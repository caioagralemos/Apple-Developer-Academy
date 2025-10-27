//
//  FocusMonitor.swift
//  FocusMonitor
//
//  Created by Alessandro Cacace on 19/10/25.
//

import Foundation
import DeviceActivity
import ManagedSettings
import FamilyControls

// This class manages what happens at the START and END
// of the monitoring session.
class FocusMonitor: DeviceActivityMonitor {
    
    private let appGroupName = "group.caioagralemos.com"
    private let userDefaultsKey = "focusAppSelection"
    // Create an instance of the store to apply rules
    private let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("BookAppFocusStore"))
    
    private func loadSelection() -> FamilyActivitySelection? {
            let defaults = UserDefaults(suiteName: appGroupName)
            let decoder = JSONDecoder()
            
            guard let data = defaults?.data(forKey: userDefaultsKey) else {
                print("MONITOR: Nessuna selezione trovata in UserDefaults.")
                return nil
            }
            
            return try? decoder.decode(FamilyActivitySelection.self, from: data)
        }
    
    // Called when the session (schedule) STARTS
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        print("📱 MONITOR: Session started! Applying restrictions...")
        
        guard let selection = loadSelection() else {
                    // If there's no selection, don't block anything
                    print("⚠️ MONITOR: No selection found")
                    store.shield.applications = nil
                    return
                }
                
        // Apply restrictions
        print("🛡️ MONITOR: Applying restrictions...")
        print("📱 Apps: \(selection.applicationTokens.count)")
        print("📂 Categories: \(selection.categoryTokens.count)")
        print("🌐 Domains: \(selection.webDomainTokens.count)")
        
        // Block individual apps
        if !selection.applicationTokens.isEmpty {
            store.shield.applications = selection.applicationTokens
        }
        
        // Block categories
        if !selection.categoryTokens.isEmpty {
            store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy.specific(selection.categoryTokens)
        }
        
        // Block web domains
        if !selection.webDomainTokens.isEmpty {
            store.shield.webDomains = selection.webDomainTokens
        }
        
        print("✅ MONITOR: Restrictions applied!")
    
    }
    
    // Called when the session (schedule) ENDS
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        print("🔓 MONITOR: Session ended! Removing restrictions...")
        
        // Remove restrictions
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        print("✅ MONITOR: Restrictions removed!")
    }
    
    // You can use this method if you want to react to a specific event
    // (like having exceeded the time threshold)
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name,  activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        print("Event threshold reached for \(event.rawValue)")
    }
}
