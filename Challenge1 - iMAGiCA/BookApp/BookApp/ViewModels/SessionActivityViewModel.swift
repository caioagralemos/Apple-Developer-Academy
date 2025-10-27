//
//  SessionActivityViewModel.swift
//  BookApp
//
//  Created by Caio on 27/10/25.
//

import Foundation
import ActivityKit
import Combine

class SessionActivityViewModel: ObservableObject {
    @Published var durationInSeconds: Int = 36000
    @Published var progress: Double = 0
    let firstDuration: Int
    let bookName: String
    let bookAuthor: String
    @Published var sessionActivity: Activity<SessionAttributes>? = nil
    
    init(durationInSeconds: Int, progress: Double, bookName: String, bookAuthor: String, sessionActivity: Activity<SessionAttributes>? = nil) {
        self.durationInSeconds = durationInSeconds
        self.firstDuration = durationInSeconds
        self.progress = progress
        self.bookName = bookName
        self.bookAuthor = bookAuthor
        self.sessionActivity = sessionActivity
        
        print("Starting Session Activity Model")
    }
    
    func startLiveActivity() {
        let attributes = SessionAttributes(bookName: bookName, bookAuthor: bookAuthor)
        let initialState = SessionAttributes.ContentState(durationInSeconds: durationInSeconds, progress: progress)
        do {
            sessionActivity = try Activity.request(attributes: attributes, content: ActivityContent(state: initialState, staleDate: nil))
        } catch {
            print("Error starting live activity: \(error)")
        }
    }
    
    func updateLiveActivity() {
        let updatedState = SessionAttributes.ContentState(durationInSeconds: durationInSeconds, progress: Double(durationInSeconds/firstDuration))
        
        Task {
            await sessionActivity?.update(ActivityContent(state: updatedState, staleDate: nil))
        }
    }
    
    func endLiveActivity(success: Bool = false) {
        let finalState = SessionAttributes.ContentState(durationInSeconds: 0, progress: 1)
        
        Task {
            if success {
                await sessionActivity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .default)
            } else {
                await sessionActivity?.end(ActivityContent(state: finalState, staleDate: nil), dismissalPolicy: .immediate)
            }
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

