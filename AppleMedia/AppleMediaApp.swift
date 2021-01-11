//
//  AppleMediaApp.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

@main
struct AppleMediaApp: App {
    
    @StateObject
    private var userPersonal = UserPersonal()
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(darkMode ? .dark : .light)
                .environmentObject(userPersonal)
        }
    }
}
