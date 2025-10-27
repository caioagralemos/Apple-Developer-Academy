//
//  BookAppApp.swift
//  BookApp
//
//  Created by Alessandro Cacace on 15/10/25.
//

import SwiftUI
import UIKit

@main
struct BookAppApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()

        let titleFont = UIFont(name: "EB Garamond", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
        let largeTitleFont = UIFont(name: "EB Garamond", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)

        appearance.titleTextAttributes = [
            .font: titleFont
        ]
        appearance.largeTitleTextAttributes = [
            .font: largeTitleFont
        ]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
