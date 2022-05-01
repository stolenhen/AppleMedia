//
//  TabNavigation.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct TabNavigation: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var selection: Tab = .topMovies
    
    var body: some View {
        TabView(selection: $selection) {
            MainGridView()
                .tabItem { Label(Tab.topMovies.tabName,
                                 systemImage: Tab.topMovies.tabImage) }
                .tag(Tab.topMovies)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            
            GlobalSearchView()
                .tabItem { Label(Tab.globalSearch.tabName,
                                 systemImage: Tab.globalSearch.tabImage) }
                .tag(Tab.globalSearch)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            
            WantToWatchView()
                .tabItem { Label(Tab.wantToWatch.tabName,
                                 systemImage: Tab.wantToWatch.tabImage) }
                .tag(Tab.wantToWatch)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            
            SettingsView()
                .tabItem { Label(Tab.settings.tabName,
                                 systemImage: Tab.settings.tabImage) }
                .tag(Tab.settings)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
        }
        .accentColor(colorScheme == .dark
                        ? Color(.systemPink)
                        : Color(.systemBlue))
    }
}

extension TabNavigation {
    enum Tab {
        case topMovies
        case globalSearch
        case wantToWatch
        case settings
        
        var tabName: String {
            switch self {
            case .topMovies: return "Top movies"
            case .globalSearch: return "Global search"
            case .wantToWatch: return "Want to watch"
            case .settings: return "Settings"
            }
        }
        
        var tabImage: String {
            switch self {
            case .topMovies: return "film"
            case .globalSearch: return "magnifyingglass"
            case .wantToWatch: return "heart"
            case .settings: return "gear"
            }
        }
    }
}


struct TabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigation()
    }
}
