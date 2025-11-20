//
//  CurtainAnimationView.swift
//  Rabisco
//
//  Created by Caio on 16/11/25.
//

import Combine
import SwiftUI

struct CurtainAnimationView: View {
    @State var number: Int
    @Binding var animationDone: Bool
    let isOpening: Bool
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()
    
    init(isOpening: Bool, animationDone: Binding<Bool>) {
        self.number = isOpening ? 6 : 1
        self.isOpening = isOpening
        self._animationDone = animationDone
    }
    
    var body: some View {
        ZStack {
            Color.clear // Ou sua view principal
                .overlay(
                    Image("curtain\(number)")
                        .resizable()
                        .frame(width: 1995, height: 1330)
                        .padding(.bottom, 120)
                        .allowsHitTesting(false)
                    , alignment: .center
                )

        }
        .onReceive(timer) { _ in
            if animationDone { return }
            
            if isOpening {
                if number > 1 {
                    number -= 1
                } else {
                    animationDone = true
                }
            } else {
                if number < 6 {
                    number += 1
                } else {
                    animationDone = true
                }
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

#Preview {
    @Previewable @State var animationDone = false
    CurtainAnimationView(isOpening: false, animationDone: $animationDone)
}
