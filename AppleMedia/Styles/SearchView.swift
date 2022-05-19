//
//  StaticSearchView.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var searchQuery: String
    
    var body: some View {
        HStack(spacing: Spacing.normal.value) {
            Image(systemName: "magnifyingglass.circle")
                .resizable()
                .squareFrame(size: 20)
                .foregroundColor(.secondary)
            TextField("Search...", text: $searchQuery)
            Button {
                searchQuery = ""
            } label: {
                Image(systemName: "multiply.circle")
                    .resizable()
                    .squareFrame(size: 18)
                    .foregroundColor(.secondary)
            }
            .opacity(searchQuery.isEmpty ? 0 : 1)
        }
        .padding(spacing: .normal)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white)
                .opacity(colorScheme == .dark ? 0.1 : 1)
        )
        .padding(.horizontal, spacing: .half)
        .frame(height: 50)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchQuery: .constant(""))
            .preferredColorScheme(.dark)
    }
}
