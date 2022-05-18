//
//  TopMediaTopView.swift
//  AppleMedia
//
//  Created by stolenhen on 01.12.2020.
//

import SwiftUI

struct TopMediaTopView: View {
    @EnvironmentObject private var userPersonal: Settings
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: TopMediaViewModel
    
    var body: some View {
        VStack(spacing: .zero) {
            Color(colorScheme == .light ? .lightMode : .darkMode)
                .frame(height: Constants.screenHeight * 0.04)
            DynamicSearchView(expand: $userPersonal.expand,
                              searchTerm: $viewModel.searchTerm,
                              title: userPersonal.countryName)
                .onReceive(viewModel.$searchTerm) { value in
                    withAnimation {
                        viewModel.sortType = .search(searchTerm: value)
                    }
                }
            if userPersonal.expand {
                genres
            }
        }
        .padding(.horizontal, spacing: .half)
        .background(Color(colorScheme == .light ? .lightMode : .darkMode))
    }
}

private extension TopMediaTopView {
    var genres: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.genresResult, id: \.self) { genre in
                    Button(action: {
                        withAnimation {
                            viewModel.select(genre)
                        }
                    }) {
                        Text(genre)
                            .font(.system(size: 14, weight: .light))
                            .padding(.vertical, spacing: .half)
                            .padding(.horizontal, spacing: .normal)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(lineWidth: 1)
                            )
                            .padding(.bottom, spacing: .normal)
                            .foregroundColor(isSelected(genre: genre) ? .pink : .white)
                    }
                    .buttonStyle(ResizableButtonStyle())
                }
            }
        }
    }
    
    func isSelected(genre: String) -> Bool {
        viewModel.genresResult.first(where: { $0 == genre }) == viewModel.currentGenre
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopMediaTopView(viewModel: TopMediaViewModel())
    }
}
