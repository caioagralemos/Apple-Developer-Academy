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
        let scene: SCNScene = {
            let s = SCNScene(named: "simple_book.usdz")!
            if let n = s.rootNode.childNodes.first {
                n.runAction(.repeatForever(.rotateBy(x: .pi*1, y: .pi*2, z: .pi*0.5, duration: 8)))
            }
            // Garantir background transparente também no nível da cena
            s.background.contents = UIColor.clear
            return s
        }()

        return TransparentSceneView(scene: scene)
            .frame(height: size)
            .background(.clear)
    }
}

struct TransparentSceneView: UIViewRepresentable {
    let scene: SCNScene

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.scene = scene
        view.autoenablesDefaultLighting = true
        view.allowsCameraControl = false
        view.isPlaying = true

        // Torna o fundo transparente
        view.backgroundColor = .clear
        view.isOpaque = false

        // Opcional: também limpar o background da cena
        scene.background.contents = UIColor.clear

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // Se precisar atualizar algo dinamicamente
        uiView.scene = scene
    }
}
