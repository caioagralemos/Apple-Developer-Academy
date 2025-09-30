//
//  ContentView.swift
//  DynamicType
//
//  Created by Joel Davies on 10/17/23.
//
//  os26 version July 2025

import SwiftUI

struct ContentView: View {
    @State private var hideStatusBar = false
    
    var body: some View {
        
        TabView {
            LearnView()
                .tabItem {
                    Label("Learn", systemImage: "lightbulb.fill")
            }
            
            AvoidView()
                .tabItem {
                    Label("Avoid", systemImage: "exclamationmark.triangle.fill")
            }

            PracticeView()
                .tabItem {
                    Label("Practice", systemImage: "paintpalette.fill")
                    
            }
            ApplyView()
                .tabItem {
                    Label("Apply", systemImage: "trophy.fill")
                }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .statusBarHidden(hideStatusBar)
        .onAppear {
            hideStatusBar = true
        }
                
    }
}

#Preview {
    ContentView()
}
