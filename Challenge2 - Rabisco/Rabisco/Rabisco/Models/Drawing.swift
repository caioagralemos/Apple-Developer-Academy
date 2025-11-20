//
//  Drawing.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import Combine
import PencilKit
import Foundation

class Drawing: ObservableObject, Identifiable {
    let id: UUID
    let title: String
    
    @Published var background: UIImage? = nil
    @Published var content: PKDrawing
    @Published var assignedArtist: Artist?
    @Published var artistNames: [String]
    
    init(title: String, assignedArtist: Artist) {
        self.id = UUID()
        self.title = title
        self.content = PKDrawing()
        self.assignedArtist = assignedArtist
        self.artistNames = [assignedArtist.name]
    }
}

struct SavedDrawing: Codable, Identifiable {
    let id: UUID
    let title: String
    let artistNames: [String]
    let imageData: Data
    
    var image: UIImage? {
        UIImage(data: imageData)
    }

    init(from drawing: Drawing) {
        self.id = drawing.id
        self.title = drawing.title
        self.artistNames = drawing.artistNames
        if let image = drawing.background {
            self.imageData = image.pngData() ?? Data()
        } else {
            self.imageData = Data()
        }
    }
    
    init(title: String, artistNames: [String], image: UIImage) {
        self.id = UUID()
        self.title = title
        self.artistNames = artistNames
        self.imageData = image.pngData() ?? Data()
    }
}