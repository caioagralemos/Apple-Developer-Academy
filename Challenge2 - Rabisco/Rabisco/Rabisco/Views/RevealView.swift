//
//  DrawingRevealView.swift
//  Rabisco
//
//  Created by Caio on 16/11/25.
//

import SwiftUI
import SwiftUINavigationTransitions

struct RevealView: View {
    @ObservedObject var experience: Experience
    @Binding var currentDrawingIndex: Int
    @Binding var revealDone: Bool
    @State var animationDone = true
    @State var isCurtainOpening = true
    @State var animationKey = UUID()
    @State var waitingToReopen = false
    @State var pendingDrawingIndex: Int? = nil
    
    var currentDrawing: Drawing {
        experience.drawings[currentDrawingIndex]
    }
    
    var body: some View {
        ZStack {
            BackgroundView(isBlue: true)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack(spacing: 30) {
                    if revealDone {
                        Button {
                            SoundManager.shared.play(.click)
                            SoundManager.shared.play(.close)
                            pendingDrawingIndex = currentDrawingIndex > 0 ? currentDrawingIndex - 1 : experience.drawings.count - 1
                            isCurtainOpening = false
                            waitingToReopen = true
                            animationDone = false
                            animationKey = UUID()
                        } label: {
                            Circle()
                                .frame(width: 50)
                                .foregroundStyle(.white)
                                .overlay(
                                    Text("<")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 35))
                                        .padding(.top, 7)
                                )
                        }
                    }
                    
                    Image("frame")
                        .resizable()
                        .frame(width: 460, height: 600)
                        .overlay(
                            Group {
                                if let background = currentDrawing.background {
                                    Image(uiImage: background)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 306, height: 364.5)
                                } else {
                                    Color.white
                                        .frame(width: 306, height: 364.5)
                                }
                            }
                        )
                    
                    if revealDone {
                        Button {
                            SoundManager.shared.play(.click)
                            SoundManager.shared.play(.close)
                            pendingDrawingIndex = currentDrawingIndex < experience.drawings.count - 1 ? currentDrawingIndex + 1 : 0
                            isCurtainOpening = false
                            waitingToReopen = true
                            animationDone = false
                            animationKey = UUID()
                        } label: {
                            Circle()
                                .frame(width: 50)
                                .foregroundStyle(.white)
                                .overlay(
                                    Text(">")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 35))
                                        .padding(.top, 7)
                                )
                        }
                    }
                }
                .padding(.top, revealDone ? 150 : 100)
                
                Rectangle()
                    .frame(width: 250, height: 80)
                    .foregroundStyle(.white)
                    .border(.black, width: 5)
                    .overlay(
                        VStack {
                            Text(currentDrawing.title)
                                .font(.custom("Baby Doll", size: 25))
                                .padding(.bottom, -7)
                            
                            Text("by \(currentDrawing.artistNames.joined(separator: ", "))")
                                .font(.system(size: 14))
                                .fontWeight(.light)
                                .italic(true)
                        }
                        .foregroundStyle(.black)
                    )
                
                if revealDone {
                    NavigationLink {
                        HomeView()
                    } label: {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundStyle(.white)
                            .frame(width: 240, height: 70)
                            .overlay(
                                Text("Done")
                                    .foregroundStyle(.black)
                                    .font(.custom("Baby Doll", size: 45)
                            ))
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        SoundManager.shared.play(.click)
                        SavedDrawingsManager.shared.saveDrawingsFromExperience(experience)
                    })
                    .navigationTransition(.fade(.in))
                }
            }
            
            CurtainAnimationView(isOpening: isCurtainOpening, animationDone: $animationDone)
                .ignoresSafeArea()
                .id(animationKey)
                .onChange(of: animationDone) {
                    if animationDone && !isCurtainOpening && waitingToReopen {
                        if let nextIndex = pendingDrawingIndex {
                            currentDrawingIndex = nextIndex
                            pendingDrawingIndex = nil
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            waitingToReopen = false
                            isCurtainOpening = true
                            animationDone = false
                            animationKey = UUID()
                            SoundManager.shared.play(.open)
                        }
                    } else if animationDone && isCurtainOpening && !revealDone {
                        SoundManager.shared.play(.tada)
                    }
                }
            
            if !revealDone && animationDone && isCurtainOpening {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        SoundManager.shared.play(.close)
                        if currentDrawingIndex < experience.drawings.count - 1 {
                            pendingDrawingIndex = currentDrawingIndex + 1
                            isCurtainOpening = false
                            waitingToReopen = true
                            animationDone = false
                            animationKey = UUID()
                        } else {
                            pendingDrawingIndex = 0
                            isCurtainOpening = false
                            waitingToReopen = true
                            animationDone = false
                            animationKey = UUID()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                                revealDone = true
                            }
                        }
                    }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                SoundManager.shared.play(.open)
                animationDone = false
                animationKey = UUID()
            }
        }
        .statusBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    RevealView(
        experience: Experience.localMock,
        currentDrawingIndex: .constant(0),
        revealDone: .constant(false)
    )
}
