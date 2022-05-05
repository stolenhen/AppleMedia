//
//  AppleMediaApp.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

@main
struct AppleMediaApp: App {
    @StateObject private var userPersonal = Settings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userPersonal)
        }
    }
}
