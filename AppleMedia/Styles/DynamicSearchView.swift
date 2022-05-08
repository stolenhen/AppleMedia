//
//  DynamicSearchVuew.swift
//  AppleMedia
//
//  Created by stolenhen on 24.12.2020.
//

import SwiftUI

struct DynamicSearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var expand: Bool
    @Binding var searchTerm: String
    let title: String
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            HStack {
                Image(systemName: "magnifyingglass.circle")
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.secondary)
                    .onTapGesture {
                        withAnimation {
                            searchTerm = ""
                            expand.toggle()
                        }
                    }
                if expand {
                    TextField("Search...", text: $searchTerm)
                    Button(action: {
                        withAnimation {
                            searchTerm = ""
                        }
                    }) {
                        if !searchTerm.isEmpty {
                            Image(systemName: "multiply.circle")
                                .foregroundColor(.secondary)
                                .font(.system(size: 18, weight: .light))
                                .padding(.trailing, 5)
                        }
                    }
                }
            }
            .frame(width: expand ? Constants.screenWidth * 0.82 : 22)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white)
                    .opacity(colorScheme == .dark ? 0.1 : 1)
            )
            Spacer()
            Text(expand ? title : title.getCountryName + " " + title.getCountryFlag)
                .font(.system(size: 16, weight: .light))
                .padding(.vertical, 5)
                .padding(.horizontal, expand ? 5 : 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .opacity(colorScheme == .dark ? 0.1 : 1))
        }
        .frame(height: 50)
    }
}

struct DynamicSearchVuew_Previews: PreviewProvider {
    static var previews: some View {
        DynamicSearchView(expand: .constant(true),
                          searchTerm: .constant("Matrix"),
                          title: "US")
    }
}
