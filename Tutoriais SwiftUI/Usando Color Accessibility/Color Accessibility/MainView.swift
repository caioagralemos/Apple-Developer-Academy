//
//  TabView.swift
//  Color Accessibility
//
//  Created by Joel Davies on 4/19/22.
//

import SwiftUI


struct MainView: View {

    @State private var hideStatusBar = false
    
    var body: some View {
        TabView {
            
            
            ContentView()
                .tabItem {
                    Label("Learn", systemImage: "lightbulb.fill")
            }
            
            AvoidView()
                .tabItem {
                    Label("Avoid", systemImage: "exclamationmark.triangle.fill")
            }

            ColorView()
                .tabItem {
                    Label("Practice", systemImage: "paintpalette.fill")
                    
            }
            AccessibilityView()
                .tabItem {
                    Label("F T W", systemImage: "trophy.fill")
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
    MainView()
}
