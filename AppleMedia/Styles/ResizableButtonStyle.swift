//
//  ResizableButtonStyle.swift
//  AppleMedia
//
//  Created by stolenhen on 24.11.2020.
//

import SwiftUI

struct ResizableButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.90 : 1)
    }
}
