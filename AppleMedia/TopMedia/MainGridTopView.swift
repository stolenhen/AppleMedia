//
//  MainGridTopView.swift
//  AppleMedia
//
//  Created by stolenhen on 01.12.2020.
//

import SwiftUI

struct MainGridTopView: View {
    
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: MainGridViewModel
    
    var genres: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.genresResult) { genre in
                    Button(
                        action: {
                            withAnimation {
                                viewModel.sortType = .filter(iD: genre.id)
                            }
                        }
                    ) {
                        VStack(spacing: 5) {
                            Text(genre.name)
                                .font(.system(size: 14, weight: .light))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(lineWidth: 1))
                                .foregroundColor(sorted(genre) ? .primary : .secondary)
                        }
                        .padding(.bottom, 10)
                    }
                    .buttonStyle(ResizableButtonStyle())
                }
            }
        }
    }
    
    var body: some View {
        
        VStack(spacing: 0) {
            Color(colorScheme == .light ? .lightMode : .darkMode)
                .frame(height: Constants.screenHeight * 0.04)
            
            DynamicSearchView(expand: $userPersonal.expand,
                              searchTerm: $viewModel.searchTerm,
                              title: userPersonal.defaultCode
                                ? "US"
                                : userPersonal.countryName.getCountryCode)
                .onReceive(viewModel.$searchTerm) { value in
                    withAnimation {
                        viewModel.sortType =
                            .search(searchTerm: value)
                    }
                }
            if userPersonal.expand { genres }
        }
        .padding(.horizontal, 5)
        .background(Color(colorScheme == .light ? .lightMode : .darkMode))
    }
    
    private func sorted(_ genre: GenreModel) -> Bool {
        viewModel.sortType == .filter(iD: genre.genreId)
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        MainGridTopView(viewModel: MainGridViewModel())
    }
}
