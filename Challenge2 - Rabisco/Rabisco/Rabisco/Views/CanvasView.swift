//
//  CanvasView.swift
//  Rabisco
//
//  Created by Caio on 13/11/25.
//

import SwiftUI
import PencilKit
import Combine

struct CanvasView: View {
    @ObservedObject var experience: Experience
    
    let drawingId: UUID
    let assignedArtist: Artist
    
    @State var timeRemaining: Int = 30
    @State var zoomScale: CGFloat = 1
    @State var exitModal = false
    @State var hasFinished = false
    @State var isUserDrawing = false
    @State var waitingForDrawingToEnd = false
    @State private var timer: AnyCancellable?
    @State private var checkTimer: AnyCancellable?
    
    var body: some View {
        ZStack {
            BackgroundView(isBlue: true)
                .ignoresSafeArea()
                
            
            VStack {
                Spacer()
                
                VStack {
                    HStack(spacing: 10) {
                        Button {
                            SoundManager.shared.play(.click)
                            withAnimation {
                                exitModal = true
                            }
                        } label: {
                            Circle()
                                .frame(width: 50)
                                .overlay(
                                    Text("<")
                                        .foregroundStyle(.black)
                                        .font(.custom("Baby Doll", size: 35))
                                        .padding(.top, 7)
                                )
                        }
 
                        Spacer()
                        
                        Text("\(timeRemaining)")
                            .font(.custom("Baby Doll", size: 55))
                        Image(systemName: "clock.fill")
                            .font(.system(size: 35))
                        #if DEBUG
                            .onLongPressGesture {
                                self.timeRemaining = 1
                            }
                        #endif
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 35)
                }
                Spacer()
                Spacer()
                
                if let index = experience.drawings.firstIndex(where: { $0.id == drawingId }) {
                    Canvas(
                        zoomScale: $zoomScale,
                        drawing: $experience.drawings[index].content,
                        phase: experience.currentPhase,
                        backgroundImage: experience.drawings[index].background,
                        isUserDrawing: $isUserDrawing
                    )
                    .frame(width: 630, height: 750)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.black, lineWidth: 20)
                    )

                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.black)
                        .opacity(0.25)
                        .frame(width: 536, height: 152)
                        .padding(.top, -30)
                        .zIndex(-1)
                        .overlay(
                            VStack {
                                switch experience.currentPhase {
                                case .Sketch:
                                    Text("You are now sketching")
                                        .fontWeight(.light)
                                        .font(.system(size: 24))
                                case .Detail:
                                    Text("You are now detailing")
                                        .fontWeight(.light)
                                        .font(.system(size: 24))
                                case .Color:
                                    Text("You are now coloring")
                                        .fontWeight(.light)
                                        .font(.system(size: 24))
                                case .Reveal:
                                    EmptyView()
                                }

                                Text(experience.drawings[index].title.uppercased())
                                    .font(.custom("Baby Doll", size: 60))
                                    .minimumScaleFactor(0.6)
                            }
                            .foregroundStyle(.white)
                        )
                } else {
                    EmptyView()
                        .frame(width: 630, height: 850)
                }
                
                Spacer()
                Spacer()
                Spacer()
                
            }
            
            if exitModal {
                ExitModalView(exitModal: $exitModal)
                    .ignoresSafeArea()
            }
        }
        .preferredColorScheme(.light)
        .navigationBarBackButtonHidden(true)
        .statusBarHidden()
        .onAppear {
            switch experience.currentPhase {
            case .Sketch:
                self.timeRemaining = 30
            case .Detail:
                self.timeRemaining = 30
            case .Color:
                self.timeRemaining = 30
            case .Reveal:
                self.timeRemaining = 0
            }
            #if DEBUG
            switch experience.currentPhase {
            case .Sketch:
                self.timeRemaining = 30
            case .Detail:
                self.timeRemaining = 30
            case .Color:
                self.timeRemaining = 30
            case .Reveal:
                self.timeRemaining = 0
            }
            #endif
            
            timer = Timer.publish(every: 1, on: .main, in: .default).autoconnect().sink { _ in
                if timeRemaining >= 1 {
                    timeRemaining -= 1
                    if timeRemaining == 5 {
                        SoundManager.shared.play(.timesup)
                    }
                } else if !hasFinished && !waitingForDrawingToEnd {
                    waitingForDrawingToEnd = true
                }
            }
            
            checkTimer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect().sink { _ in
                if waitingForDrawingToEnd && !isUserDrawing && !hasFinished {
                    hasFinished = true
                    experience.finishPhase(for: drawingId, canvasSize: CGSize(width: 630, height: 750))
                }
            }
        }
        .onDisappear {
            timer?.cancel()
            checkTimer?.cancel()
        }
    }
}


#Preview {
    CanvasView(experience: Experience.localMock, drawingId: Experience.localMock.drawings.first!.id, assignedArtist: Experience.localMock.artists.first!)
}
