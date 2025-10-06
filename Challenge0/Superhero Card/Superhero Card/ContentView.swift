//
//  ContentView.swift
//  Superhero Card
//
//  Created by Caio on 03/10/25.
//

import SwiftUI
import CoreMotion
internal import Combine
import UniformTypeIdentifiers

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) / 2
        let points = (0..<5).map { i -> CGPoint in
            let angle = (Double(i) * (2.0 * .pi / 5.0)) - .pi / 2
            return CGPoint(
                x: center.x + CGFloat(cos(angle)) * r,
                y: center.y + CGFloat(sin(angle)) * r
            )
        }
        var path = Path()
        for i in 0..<5 {
            let next = (i * 2) % 5
            if i == 0 {
                path.move(to: points[next])
            } else {
                path.addLine(to: points[next])
            }
        }
        path.closeSubpath()
        return path
    }
}

final class Motion: ObservableObject {
    private let mgr = CMMotionManager()
    
    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    
    init() {
        mgr.deviceMotionUpdateInterval = 1/60
        if mgr.isDeviceMotionAvailable {
            mgr.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
                guard let attitude = motion?.attitude else { return }
                self?.pitch = max(-.pi/6, min(.pi/6, attitude.pitch))
                self?.roll  = max(-.pi/6, min(.pi/6, attitude.roll))
            }
        }
    }
}

struct ContentView: View {
    @StateObject var motion = Motion()
    @State private var showShareSheet = false
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        let x = motion.pitch
        let y = -motion.roll
        
        ZStack {
            Color.red
                .ignoresSafeArea()
            VStack {
                CardView(x: x, y: y)
                
                ShareLink(
                    item: CardView(x: 0, y: 0).snapshot(),
                    preview: SharePreview("Caio's Superhero", image: CardView(x: 0, y: 0).snapshot(),
                        ), label: {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.blue)
                        .frame(width: 170, height: 50)
                        .overlay {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundStyle(Color.white)
                                Text("Share")
                                    .foregroundStyle(Color.white)
                            }
                        }
                }).padding(10)
            }
        }
    }
}

#Preview {
    ContentView()
}
