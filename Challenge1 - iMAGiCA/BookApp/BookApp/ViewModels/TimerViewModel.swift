//
//  TimerViewModel.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import Foundation
import Combine // Import Combine for the Timer
import UIKit // For background task handling
import UserNotifications // For local notifications

class TimerViewModel: ObservableObject {

    // States the timer can be in
    enum TimerState {
        case running
        case paused
        case finished
    }

    // Published properties that the View will observe
    @Published var remainingSeconds: Int
    @Published var formattedTime: String = "00:00"
    @Published var timerState: TimerState = .paused // Start paused

    private var timerSubscription: AnyCancellable?
    private let initialDuration: Int // Keep the starting duration
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    // Callback for when timer finishes
    var onTimerFinished: (() -> Void)?

    // Initialize with the duration selected by the user
    init(initialSeconds: Int) {
        self.initialDuration = initialSeconds
        self.remainingSeconds = initialSeconds
        self.formattedTime = formatTime(seconds: initialSeconds)
        
        // Request notification permission
        requestNotificationPermission()
    }

    // Start or resume the timer
    func startOrResume(viewModel: SessionActivityViewModel) {
        guard timerState != .running else { return } // Don't start if already running

        // If finished, reset before starting
        if timerState == .finished {
            reset()
        }

        // Request background execution time
        startBackgroundTask()
        
        timerState = .running
        print("⏱️ Timer started/resumed. Remaining: \(remainingSeconds)s")

        // Create a timer that fires every second on the main thread
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                    viewModel.durationInSeconds -= 1
                    viewModel.progress = min(Double(viewModel.durationInSeconds / viewModel.firstDuration), 1.0)
                    viewModel.updateLiveActivity()
                    self.formattedTime = self.formatTime(seconds: self.remainingSeconds)
                } else {
                    // Timer finished
                    self.timerState = .finished
                    self.timerSubscription?.cancel() // Stop the timer
                    self.endBackgroundTask() // End background task
                    viewModel.endLiveActivity(success: true)
                    print("🎉 Timer finished!")
                    
                    // Send notification
                    self.sendCompletionNotification()
                    
                    // Call callback when timer finishes
                    self.onTimerFinished?()
                }
            }
    }

    // Pause the timer
    func pause() {
        guard timerState == .running else { return } // Only pause if running
        timerState = .paused
        timerSubscription?.cancel() // Stop the timer publisher
        endBackgroundTask() // End background task when pausing
        print("⏸️ Timer paused. Remaining: \(remainingSeconds)s")
    }

    // Reset the timer to the initial duration (optional)
    func reset() {
        remainingSeconds = initialDuration
        formattedTime = formatTime(seconds: initialDuration)
        timerState = .paused // Go back to paused state
        timerSubscription?.cancel()
        print("🔄 Timer reset to \(initialDuration)s")
    }

    // Helper to format time
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }

    // Background task management
    private func startBackgroundTask() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "TimerBackgroundTask") {
            // This block is called when the background task is about to expire
            print("⚠️ Background task expiring, ending gracefully")
            self.endBackgroundTask()
        }
        print("🔄 Background task started")
    }
    
    private func endBackgroundTask() {
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
            print("✅ Background task ended")
        }
    }
    
    // Notification methods
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else {
                print("❌ Notification permission denied")
            }
        }
    }
    
    private func sendCompletionNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Focus Session Completed! 🎉"
        content.body = "Congratulations! You completed your reading session."
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "focus-session-completed",
            content: content,
            trigger: nil // Send immediately
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error)")
            } else {
                print("📱 Completion notification sent")
            }
        }
    }
    
    // Clean up timer when the ViewModel is deinitialized
    deinit {
        timerSubscription?.cancel()
        endBackgroundTask()
        print("🗑️ TimerViewModel deinitialized.")
    }
}
