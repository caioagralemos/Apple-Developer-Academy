//
//  CardView.swift
//  Superhero Card
//
//  Created by Caio on 03/10/25.
//

import SwiftUI
import UIKit

struct CardView: View {
    let x: Double
    let y: Double
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            
            VStack {
                Text("LAMPIÃO")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.white)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 300, height: 400)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .overlay {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 280, height: 380)
                            .cornerRadius(20)
                            .shadow(radius: 10)
                            .overlay {
                                Image("space")
                                    .resizable()
                                    .frame(width: 260, height: 360)
                                    .cornerRadius(20)
                                    .shadow(radius: 10)
                                    .overlay {
                                        ZStack {
                                            Rectangle()
                                                .fill(Color.black)
                                                .frame(width: 260, height: 360)
                                                .cornerRadius(20)
                                                .shadow(radius: 10)
                                                .opacity(0.6)
                                            
                                            Image("superhero")
                                                .cornerRadius(20)
                                        }
                                    }
                                    .overlay {
                                        ZStack {
                                            gloss(x: x, y: y)
                                                .allowsHitTesting(false)
                                                .frame(width: 260, height: 360)
                                            stars(x: x, y: y)
                                                .allowsHitTesting(false)
                                                .frame(width: 260, height: 360)
                                                .rotation3DEffect(.degrees(x * (45/2) / .pi), axis: (1,0,0))
                                                .rotation3DEffect(.degrees(y * (45/2) / .pi), axis: (0,1,0))
                                        }
                                    }
                            }
                    }
                    .frame(width: 300, height: 400)
                    .rotation3DEffect(.degrees(x * (45/2) / .pi), axis: (1,0,0))
                    .rotation3DEffect(.degrees(y * (45/2) / .pi), axis: (0,1,0))
                    .frame(width: 260, height: 360)
                    .padding()
                
                Text("Caio Agra Lemos")
                    .font(.title)
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 10)
                
                Group {
                    Text("Powers")
                        .font(.headline)
                    Text("Coding, Design and Making Friends")
                        .fontWeight(.light)
                }.foregroundStyle(.white)
                
                Group {
                    Text("Weakness")
                        .font(.headline)
                    Text("Business, View Transitions")
                        .fontWeight(.light)
                }.foregroundStyle(.white)
                
                Group {
                    Text("Famous for")
                        .font(.headline)
                    Text("Being nice and joyful")
                        .fontWeight(.light)
                }.foregroundStyle(.white)
            }.padding()
        }
    }
    
    private func gloss(x: Double, y: Double) -> some View {
        let cx = 0.5 + y*0.45, cy = 0.2 + x*0.35
        return RoundedRectangle(cornerRadius: 24)
            .fill(
                LinearGradient(stops: [
                    .init(color: .white.opacity(0.0), location: 0.0),
                    .init(color: .white.opacity(0.32), location: 0.38),
                    .init(color: .white.opacity(0.32), location: 0.62),
                    .init(color: .white.opacity(0.0), location: 1.0)
                ],
                startPoint: .init(x: cx-0.25, y: cy-0.5),
                endPoint:   .init(x: cx+0.25, y: cy+0.5))
            )
            .blendMode(.screen)
    }
    
    private func stars(x: Double, y: Double) -> some View {
        let off = CGSize(width: y*30, height: x*30)
        return ZStack {
            ForEach(0..<18, id:\.self) { i in
                StarShape()
                    .fill(RadialGradient(gradient: Gradient(colors: [.white, .clear]), center: .center, startRadius: 0, endRadius: 6))
                    .frame(width: 32, height: 32)
                    .position(x: CGFloat((i*37)%240)+20, y: CGFloat((i*91)%320)+20)
                    .opacity(0.38)
            }
        }
        .offset(off)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .blendMode(.screen)
    }
}
