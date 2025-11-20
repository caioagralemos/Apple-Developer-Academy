//
//  ExperienceView.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import Combine
import SwiftUI

struct ExperienceView: View {
    @StateObject var experience: Experience
    @Environment(\.dismiss) var dismiss
    @State private var showingRevealPreparation = true
    @State private var currentDrawingIndex = 0
    @State private var hasSeenAllDrawings = false
    
    var body: some View {
        if experience.currentPhase == .Reveal {
            if showingRevealPreparation {
                PreparationView(experience: experience, firstTime: true, artistName: nil)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showingRevealPreparation = false
                        }
                    }
            } else {
                RevealView(
                    experience: experience,
                    currentDrawingIndex: $currentDrawingIndex,
                    revealDone: $hasSeenAllDrawings
                )
                .onAppear {
                    if currentDrawingIndex >= experience.drawings.count - 1 && !hasSeenAllDrawings {
                        hasSeenAllDrawings = true
                    }
                }
            }
        } else if experience.isPreparing {
            let firstTime = experience.currentArtistIndex == 0
            let artistName = experience.getCurrentArtist()?.name
            PreparationView(experience: experience, firstTime: firstTime, artistName: artistName)
        } else {
            if let drawing = experience.getCurrentDrawing(), let artist = experience.getCurrentArtist() {
                CanvasView(experience: experience, drawingId: drawing.id, assignedArtist: artist)
            }
        }
    }
}
