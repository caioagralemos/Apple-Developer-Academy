//
//  SavedDrawingsManager.swift
//  Rabisco
//
//  Created by Caio on 16/11/25.
//

import Foundation
import SwiftUI

class SavedDrawingsManager {
    static let shared = SavedDrawingsManager()
    private let key = "savedDrawings"
    private let maxDrawings = 10

    func getPlaceholderDrawing() -> SavedDrawing? {
        let placeholderData: [(imageName: String, title: String, artists: [String])] = [
            ("placeholder1", "Ghost", ["Claudio", "Diego", "Daniel"]),
            ("placeholder2", "Snowman", ["Barbara", "Julia", "João"]),
            ("placeholder3", "Cat", ["Giuseppe", "Caio", "Leticia"])
        ]
        
        guard let randomPlaceholder = placeholderData.randomElement(),
            let image = UIImage(named: randomPlaceholder.imageName) else {
            return nil
        }
        
        return SavedDrawing(
            title: randomPlaceholder.title,
            artistNames: randomPlaceholder.artists,
            image: image
        )
    }
    
    func saveDrawingsFromExperience(_ experience: Experience) {
        let drawingsToSave = experience.drawings.shuffled().prefix(3)
        
        var saved = getSavedDrawings()
        
        if saved.count >= maxDrawings {
            let indicesToRemove = (0..<saved.count).shuffled().prefix(3)
            saved = saved.enumerated()
                .filter { !indicesToRemove.contains($0.offset) }
                .map { $0.element }
        }
        
        for drawing in drawingsToSave {
            let newDrawing = SavedDrawing(from: drawing)
            saved.insert(newDrawing, at: 0)
        }
        
        if saved.count > maxDrawings {
            saved = Array(saved.prefix(maxDrawings))
        }
        
        if let encoded = try? JSONEncoder().encode(saved) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func getSavedDrawings() -> [SavedDrawing] {
        guard let data = UserDefaults.standard.data(forKey: key),
            let drawings = try? JSONDecoder().decode([SavedDrawing].self, from: data),
            !drawings.isEmpty else {
            if let placeholder = getPlaceholderDrawing() {
                return [placeholder]
            }
            return []
        }
        return drawings
    }

    func getRandomDrawing() -> SavedDrawing? {
        let drawings = getSavedDrawings()
        return drawings.isEmpty ? getPlaceholderDrawing() : drawings.randomElement()
    }
}
