//
//  EnvironmentModel.swift
//  BookApp
//
//  Created by Alessandro Cacace on 22/10/25.
//

import Foundation

struct EnvironmentModel: Identifiable,Equatable {
    
    var id = UUID()
    var emoji: String
    var name: Name
    var isSelected: Bool = false
    
}

enum Name: String, Codable, CaseIterable {
    case custom = "Custom"
    case lofi = "Lo-fi"
    case rainyday = "Rainy Day"
    case piano = "Piano"
    case forest = "Forest"
    case wind = "Wind"
   
}
