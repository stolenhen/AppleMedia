//
//  Constants.swift
//  AppleMedia
//
//  Created by stolenhen on 23.12.2020.
//

import SwiftUI

enum Constants {
    static let screenWidth  = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

enum Spacing: CGFloat {
    case zero = 0.0
    case half = 5.0
    case normal = 10.0
    case double = 20.0
    
    var value: CGFloat { rawValue }
}
