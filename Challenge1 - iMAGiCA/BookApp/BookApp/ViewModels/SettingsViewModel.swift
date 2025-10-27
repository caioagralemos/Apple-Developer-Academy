//
//  SettingsViewModel.swift
//  BookApp
//
//  Created by Alessandro Cacace on 17/10/25.
//

import Foundation
import SwiftUI

class SettingsViewModel {
    
    var settings: [SettingModel] = [
        SettingModel(symbolname: "pencil", name: "Edit profile"),
        SettingModel(symbolname: "hourglass", name: "Focus Mode"),
        SettingModel(symbolname: "questionmark.circle", name: "Help & Support"),
        SettingModel(symbolname: "info.circle", name: "About"),
    ]
}

