//
//  FocusViewModel.swift
//  BookApp
//
//  Created by Alessandro Cacace on 21/10/25.
//

import Foundation
import SwiftUI
import Combine

class FocusViewModel: ObservableObject {
    @Published var timeInSeconds: Int = 0 {
        didSet {
            // Update formatted text every time timeInSeconds changes
            formattedTime = formatTime(seconds: timeInSeconds)
        }
    }
    @Published var formattedTime: String = "00:00"
    

    init() {
        self.timeInSeconds = 10 * 60
        self.formattedTime = formatTime(seconds: self.timeInSeconds)
    }
    
    // Function to format seconds into MM:SS
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    // Update time based on drag angle
    func updateTimeFromAngle(angle: Angle) {
        let totalDegrees = angle.degrees
        let percentage = totalDegrees / 360.0
        
        
        let maxTimeInMinutes = 120/5 - 1// 2 hours
        
        let newMinutes = 2 + Int(percentage * Double(maxTimeInMinutes))
        self.timeInSeconds = newMinutes * 60 * 5
    }
    
    // Methods for Scan/Add (to be implemented)
    func scanBook() {
        print("Scan book")
        // Implement scanning logic here
    }
    
    func addBook() {
        print("Add book manually")
        // Implement manual addition logic here
    }
}
