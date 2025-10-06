//
//  Extensions.swift
//  Superhero Card
//
//  Created by Caio on 03/10/25.
//

import SwiftUI

extension View {
    @MainActor
    func snapshot() -> Image {
        let renderer = ImageRenderer(content: self)
        return Image(uiImage: renderer.uiImage!)
    }
}
