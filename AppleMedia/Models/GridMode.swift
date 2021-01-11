//
//  GridMode.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

enum GridMode {
    
    case flexible(columnsCount: Int, spacing: CGFloat)
   
    var columns: [GridItem] {
        switch self {
        case let .flexible(count, spacing):
            return
                Array(repeating: GridItem(.flexible(), spacing: spacing), count: count)
        }
    }
}
