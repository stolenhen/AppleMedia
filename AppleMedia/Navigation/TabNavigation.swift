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
            ForEach(Tab.allCases) { tab in
                tab.view
                    .tabItem {
                        Label(tab.tabName, systemImage: tab.tabImage)
                    }
                    .tag(tab)
                    .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            }
        }
        .accentColor(colorScheme == .dark ? Color(.systemPink) : Color(.systemBlue))
    }
}

private extension TabNavigation {
    enum Tab: CaseIterable, Identifiable {
        case topMovies
        case globalSearch
        case wantToWatch
        case settings
       
        var id: String { tabName }
        
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
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .topMovies:
                 TopMediaView()
            case .globalSearch:
                 GlobalSearchView()
            case .wantToWatch:
                 WantToWatchView()
            case .settings:
                 SettingsView()
            }
        }
    }
}


struct TabNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabNavigation()
    }
}
