//
//  BackgroundView.swift
//  Rabisco
//
//  Created by Caio on 16/11/25.
//

import SwiftUI

struct BackgroundView: View {
    let isBlue: Bool
    
    init(isBlue: Bool = false) {
        self.isBlue = isBlue
    }
    var body: some View {
        Rectangle()
            .foregroundStyle(.white)
            .ignoresSafeArea()
            .zIndex(-2)
        
        Image("background")
            .resizable()
            .ignoresSafeArea()
            .opacity(0.1)
            .scaledToFill()
        
        if isBlue {
            LinearGradient(
                colors: [
                    Color(hex: "0049DC"),
                    Color(hex: "0044CE")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(0.65)
            .ignoresSafeArea()
        }
    }
}

struct AnimatedBackgroundView: View {
    @State private var scale: CGFloat = 1.2
    @State private var offsetX: CGFloat = -20
    @State private var offsetY: CGFloat = -16
    
    var body: some View {
        BackgroundView(isBlue: true)
            .scaleEffect(scale)
            .offset(x: offsetX, y: offsetY)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 5)
                    .repeatForever(autoreverses: true)
                ) {
                    scale = 1.3
                }
                
                withAnimation(
                    .easeInOut(duration: 6)
                    .repeatForever(autoreverses: true)
                ) {
                    offsetX = 20
                }
                
                withAnimation(
                    .easeInOut(duration: 7)
                    .repeatForever(autoreverses: true)
                ) {
                    offsetY = 16
                }
            }
    }
}
