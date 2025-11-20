//
//  Experience.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import UIKit
import Combine
import PencilKit
import Foundation
import CoreGraphics

enum ExperiencePhase: Int, Codable {
    case Sketch = 1, Detail = 2, Color = 3, Reveal = 4
}

enum ExperienceType: String, Codable {
    case Local, Online
}

class Experience: ObservableObject, Identifiable {
    static var localMock = Experience(artists: [Artist("Caio", favoriteTopic: .Places), Artist("Leticia", favoriteTopic: .Pop), Artist("Marcos", favoriteTopic: .Animals)], type: .Local)
    static var onlineMock = Experience(artists: [Artist("Caio", favoriteTopic: .Places), Artist("Leticia", favoriteTopic: .Pop), Artist("Marcos", favoriteTopic: .Animals)], type: .Online)
    
    let id: UUID
    let type: ExperienceType
    @Published var artists: [Artist]
    @Published var isPreparing: Bool = true
    @Published var currentPhase: ExperiencePhase
    @Published var drawings: [Drawing]
    @Published var currentArtistIndex: Int = 0
    
    let rotationOrder: [UUID]
    private var drawingRotationMap: [UUID: [UUID]] = [:]
    
    init(artists: [Artist], type: ExperienceType) {
        self.id = UUID()
        self.artists = artists
        self.type = type
        self.currentPhase = .Sketch
        self.drawings = []
        self.rotationOrder = artists.map { $0.id }
        
        let shuffledArtists = artists.shuffled()
        let n = shuffledArtists.count
        
        for (i, artist) in shuffledArtists.enumerated() {
            let drawing = Drawing(title: artist.favoriteTopic.getRandomTopic(), assignedArtist: artist)
            drawings.append(drawing)
            
            let rotationSequence: [UUID] = [
                shuffledArtists[i].id,
                shuffledArtists[(i + 1) % n].id,
                shuffledArtists[(i + 2) % n].id
            ]
            drawingRotationMap[drawing.id] = rotationSequence
        }
    }
    
    func advancePhase() {
        switch currentPhase {
        case .Sketch: currentPhase = .Detail
        case .Detail: currentPhase = .Color
        case .Color: currentPhase = .Reveal
        case .Reveal: break
        }
        
        self.currentArtistIndex = 0
        self.isPreparing = true
        
        if self.currentPhase != .Reveal {
            rotateDrawings()
        }
    }
    
    private func rotateDrawings() {
        guard artists.count > 1 else { return }
        for drawing in drawings {
            if self.currentPhase == .Reveal {
                drawing.assignedArtist = nil
            } else {
                drawing.assignedArtist = nextArtist(for: drawing)
                if let artist = drawing.assignedArtist {
                    drawing.artistNames.append(artist.name)
                }
            }
        }
    }
    
    private func nextArtist(for drawing: Drawing) -> Artist? {
        guard let sequence = drawingRotationMap[drawing.id] else { return nil }
        let currentPhaseIndex = currentPhase.rawValue - 1
        guard currentPhaseIndex < sequence.count else { return nil }
        let artistId = sequence[currentPhaseIndex]
        return artists.first(where: { $0.id == artistId })
    }
    
    func mergeImages(base: UIImage, overlay: UIImage) -> UIImage {
        let size = base.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        base.draw(in: CGRect(origin: .zero, size: size))
        overlay.draw(in: CGRect(origin: .zero, size: size))

        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return result
    }
    
    func finishPhase(for drawingId: UUID, canvasSize: CGSize, finalDrawing: PKDrawing? = nil) {
            guard let index = drawings.firstIndex(where: { $0.id == drawingId }) else { return }
            let drawing = drawings[index]

            let rect = CGRect(origin: .zero, size: canvasSize)
            let scale = UIScreen.main.scale
            let drawingToUse = finalDrawing ?? drawing.content
            let newLayer = drawingToUse.image(from: rect, scale: scale)

            if let existing = drawing.background {
                drawing.background = mergeImages(base: existing, overlay: newLayer)
            } else {
                drawing.background = newLayer
            }

            drawing.content = PKDrawing()
            
            currentArtistIndex += 1
            
            if currentArtistIndex >= artists.count {
                self.advancePhase()
            } else {
                self.isPreparing = true
            }
        }
    
    func getCurrentDrawing() -> Drawing? {
        guard let currentArtist = getCurrentArtist() else { return nil }
        return drawings.first(where: { $0.assignedArtist?.id == currentArtist.id })
    }
    
    func getCurrentArtist() -> Artist? {
        guard currentArtistIndex < artists.count else { return nil }
        return artists[currentArtistIndex]
    }
}

