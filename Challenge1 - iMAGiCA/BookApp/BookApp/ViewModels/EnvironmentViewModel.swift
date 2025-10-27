//
//  EnvironmentViewModel.swift
//  BookApp
//
//  Created by Alessandro Cacace on 22/10/25.
//

import Foundation
import SwiftUI
import Combine


class EnvironmentViewModel: ObservableObject {
    @Published var environments: [EnvironmentModel] = [
        EnvironmentModel(emoji: "🎭", name: Name.custom, isSelected: true),
        EnvironmentModel(emoji: "🎧", name: Name.lofi),
        EnvironmentModel(emoji: "🌧️", name: Name.rainyday),
        EnvironmentModel(emoji: "🎹", name: Name.piano),
        EnvironmentModel(emoji: "🌲", name: Name.forest),
        EnvironmentModel(emoji: "💨", name: Name.wind),
        
        ]
    
    func selectEnvironment(_ environmentToSelect: EnvironmentModel) {
        environments = environments.map { environment in
            var mutableEnvironment = environment
            mutableEnvironment.isSelected = (environment.id == environmentToSelect.id)
            return mutableEnvironment
        }
    }
    
    func resetSelections() {
        environments = environments.map { environment in
            var mutableEnvironment = environment
            mutableEnvironment.isSelected = false
            return mutableEnvironment
        }
    }

}
