//
//  SettingsModel.swift
//  AppleMedia
//
//  Created by stolenhen on 29.11.2020.
//

import Foundation

struct SettingsModel: Identifiable {
    var id: String { UUID().uuidString }
    
    let nightShift: Bool
    let country: String
}

struct SettingItem: Identifiable {
    var id: String { title }
    
    let title: String
    let icon: String
    let type: SettingsType
}

enum SettingsType {
    case country
    case mode
    case cleanStorage
}
