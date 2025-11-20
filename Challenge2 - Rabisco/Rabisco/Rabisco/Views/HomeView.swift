//
//  HomeView.swift
//  Rabisco
//
//  Created by Caio on 11/11/25.
//

import SwiftUI
import SwiftUINavigationTransitions

struct HomeView: View {
    @State var isModalOpen = false
    @State var displayDrawing: SavedDrawing? = nil
    var body: some View {
        NavigationStack {
            ZStack {
                AnimatedBackgroundView()
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 20) {
                        ZStack {
                            Image("frame")
                                .resizable()
                                .frame(width: 405, height: 533)
                            VStack {
                                if let drawing = displayDrawing, let image = drawing.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 184, height: 298)
                                    Text(drawing.title)
                                        .fontWeight(.medium)
                                    Text("by \(drawing.artistNames.joined(separator: ", "))")
                                        .fontWeight(.light)
                                } else {
                                    Image("drawing")
                                        .resizable()
                                        .frame(width: 184*1.2, height: 298*1.2)
                                    Text("Bulldog")
                                        .fontWeight(.medium)
                                    Text("by Mario, Luigi and Peach")
                                        .fontWeight(.light)
                                }
                            }
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        }
                        #if DEBUG
                        .onLongPressGesture {
                            UserDefaults.standard.set([], forKey: "savedDrawings")
                            displayDrawing = SavedDrawingsManager.shared.getPlaceholderDrawing()
                        }
                        #endif
                    }
                    .padding(.bottom)
                    
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 609, height: 159)
                        .padding(.bottom, 30)
                    
                    HStack(spacing: 30) {
                        Button {
                            SoundManager.shared.play(.click)
                            isModalOpen = true
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 240, height: 75)
                                .foregroundStyle(.white)
                                .overlay(
                                    Text("Local")
                                        .font(.custom("Baby Doll", size: 60))
                                        .foregroundStyle(.black)
                                )
                        }
                        
                        NavigationLink {
                            ExperienceView(experience: .localMock)
                                .gesture(DragGesture())
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .frame(width: 240, height: 75)
                                .foregroundStyle(.white)
                                .overlay(
                                    Text("Online")
                                        .font(.custom("Baby Doll", size: 60))
                                        .foregroundStyle(.black)
                                )
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            SoundManager.shared.play(.click)
                        })
                        .navigationTransition(.fade(.in))
                    }
                }
                
                if isModalOpen {
                    OnboardingModalView(exitModal: $isModalOpen)
                        .ignoresSafeArea()
                }
            }
            .statusBarHidden()
            .onAppear {
                displayDrawing = SavedDrawingsManager.shared.getRandomDrawing()
                SoundManager.shared.playBackgroundMusic(volume: 0.1)
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeView()
}
