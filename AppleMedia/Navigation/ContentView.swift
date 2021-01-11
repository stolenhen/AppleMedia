//
//  ContentView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct ContentView: View {

    @StateObject
    private var userPersonal: UserPersonal = UserPersonal()
    
    var body: some View {
       
        TabNavigation()
            .environmentObject(userPersonal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
