//
//  ExitModalView.swift
//  Rabisco
//
//  Created by Caio on 15/11/25.
//

import SwiftUI
import SwiftUINavigationTransitions

struct ExitModalView: View {
    @Binding var exitModal: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .opacity(0.7)
                .onTapGesture {
                    withAnimation {
                        exitModal = false
                    }
                }
            
            ZStack {
                Image("frame")
                    .resizable()
                    .frame(width: 430, height: 580)
                VStack {
                    Image("exit")
                        .resizable()
                        .frame(width: 120, height: 210)
                    
                    Text("Leaving so soon,\nPicasso?")
                        .font(.custom("Baby Doll", size: 30))
                        .frame(width: 250)
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    
                    HStack(spacing: 20) {
                        NavigationLink {
                            HomeView()
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(.black)
                                .frame(width: 120, height: 75)
                                .overlay(
                                    Text("YES")
                                )
                        }
                        .simultaneousGesture(TapGesture().onEnded {
                            SoundManager.shared.play(.click)
                        })
                        .navigationTransition(.fade(.in))
                        
                        Button {
                            SoundManager.shared.play(.click)
                            withAnimation {
                                exitModal = false
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 30)
                                .foregroundStyle(.black)
                                .frame(width: 120, height: 75)
                                .overlay(
                                    Text("NO")
                                )
                        }
                    }
                    .font(.custom("Baby Doll", size: 48))
                    .foregroundStyle(.white)
                }
            }
            .rotationEffect(Angle(degrees: 0.5))
        }
    }
}
