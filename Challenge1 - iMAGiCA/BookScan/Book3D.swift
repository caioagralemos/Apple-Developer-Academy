//
//  Book3D.swift
//  Tests
//
//  Created by Caio on 15/10/25.
//


import SwiftUI
import SceneKit

struct Book3D: View {
    var size: CGFloat = 50
    var body: some View {
        SceneView(
          scene: {
            let s = SCNScene(named: "simple_book.usdz")!
            if let n = s.rootNode.childNodes.first {
                n.runAction(.repeatForever(.rotateBy(x: .pi*1, y: .pi*2, z: .pi*0.5, duration: 8)))
            }
            return s
          }(),
          options: [.autoenablesDefaultLighting]
        ).frame(height: size)
    }
}
