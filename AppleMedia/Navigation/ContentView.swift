//
//  ContentView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("darkMode") private var darkMode = false
    
    var body: some View {
        TabNavigation()
            .preferredColorScheme(darkMode ? .dark : .light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
