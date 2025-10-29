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
    let endDate: Date
    let bookName: String
    let bookAuthor: String
    @Published var sessionActivity: Activity<SessionAttributes>? = nil
    
    init(durationInSeconds: Int, bookName: String, bookAuthor: String, sessionActivity: Activity<SessionAttributes>? = nil) {
        self.endDate = Date.now.addingTimeInterval(TimeInterval(durationInSeconds))
        self.bookName = bookName.isEmpty ? "O Alquimista" : bookName
        self.bookAuthor = bookAuthor.isEmpty ? "Paulo Coelho" : bookAuthor
        self.sessionActivity = sessionActivity
        
        print("Starting Session Activity Model")
    }
    
    func startLiveActivity() {
        let attributes = SessionAttributes(bookName: bookName, bookAuthor: bookAuthor)
        let contentState = SessionAttributes.ContentState(endDate: endDate)
        do {
            sessionActivity = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: contentState, staleDate: Date() + 60)
            )
            print("Live Activity started: \(String(describing: sessionActivity))")
        } catch {
            print("Error starting live activity: \(error)")
        }
    }
    
    func endLiveActivity(success: Bool = false) {
        let finalState = SessionAttributes.ContentState(endDate: endDate)
        
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

