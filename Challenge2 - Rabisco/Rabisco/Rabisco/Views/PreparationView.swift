//
//  PreparationView.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import Combine
import SwiftUI

struct PreparationView: View {
    @ObservedObject var experience: Experience
    var firstTime: Bool
    var artistName: String?
    
    @State var loadingTime = 7
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {            
            BackgroundView()
                .ignoresSafeArea()
                .onTapGesture {
                    #if DEBUG
                    experience.isPreparing = false
                    #else
                    if loadingTime <= 5 {
                        experience.isPreparing = false
                    }
                    #endif
                }
            
            VStack(spacing: -5) {
                switch experience.currentPhase {
                case .Sketch:
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 120))
                        .padding(.vertical, 30)
                case .Detail:
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 120))
                        .padding(.vertical, 30)
                case .Color:
                    Image(systemName: "paintpalette")
                        .font(.system(size: 120))
                        .padding(.vertical, 30)
                case .Reveal:
                    Image(systemName: "photo.artframe")
                        .font(.system(size: 120))
                        .padding(.vertical, 30)
                }
                
                if experience.currentPhase != .Reveal {
                    Text("Phase \(experience.currentPhase.rawValue)")
                        .font(.system(size: 24))
                }
                Text(String(describing: experience.currentPhase))
                    .font(.custom("Baby Doll", size: 120))
                
                if let name = artistName {
                    if (firstTime == true && loadingTime <= 5) || firstTime == false {
                        Text("Pass the device to \(name)")
                            .font(.custom("Baby Doll", size: 24))
                            .opacity(0.6)
                    }
                }
    
                if loadingTime == 0 {
                    Text("Tap anywhere to continue")
                        .foregroundStyle(.black)
                        .font(.system(size: 12, weight: .light))
                        .padding(.top, 8)
                        .italic()
                }
            }
            .foregroundStyle(.black)
        }
        .statusBarHidden()
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden()
        .onReceive(timer) { _ in
            withAnimation {
                if loadingTime > 0 {
                    loadingTime -= 1
                } else {
                    timer.upstream.connect().cancel()
                }
            }
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
    }
}

#Preview {
    PreparationView(experience: Experience.localMock, firstTime: true, artistName: "Caio")
}
