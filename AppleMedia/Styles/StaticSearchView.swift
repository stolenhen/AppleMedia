//
//  StaticSearchView.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import SwiftUI

struct StaticSearchView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @Binding var searchTerm: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 18, weight: .light))
                    .padding(1)
                    .foregroundColor(.secondary)
                
                TextField("Search...", text: $searchTerm)
                
                Button(
                    action: {
                        withAnimation {
                            searchTerm = "" } })
                {
                    Image(systemName: "multiply.circle")
                        .foregroundColor(.secondary)
                        .font(.system(size: 18, weight: .light))
                        .padding(.trailing, 5)
                }
            }
            .padding(5)
            .background(RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white).opacity(colorScheme == .dark ? 0.1 : 1))
        }
        .frame(height: 50)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        StaticSearchView(searchTerm: .constant(""))
    }
}
