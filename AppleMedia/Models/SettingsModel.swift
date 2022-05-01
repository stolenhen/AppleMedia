//
//  SettingsModel.swift
//  AppleMedia
//
//  Created by stolenhen on 29.11.2020.
//

import Foundation

struct SettingsModel: Identifiable {
    let nightShift: Bool
    let country: String
    
    var id: String { country }
}

struct SettingItem: Identifiable {
    let title: String
    let icon: String
    let type: SettingsType
    
    var id: String { title }
}

enum SettingsType {
    case country
    case mode
    case cleanStorage
}
