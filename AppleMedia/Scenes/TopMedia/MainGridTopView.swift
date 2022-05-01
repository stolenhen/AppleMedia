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
}

private extension MainGridTopView {
    var genres: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.genresResult, id: \.self) { genre in
                    Button(action: {
                        withAnimation { viewModel.sortType = .filter(iD: genre) }
                    }) {
                        VStack(spacing: 5) {
                            Text(genre)
                                .font(.system(size: 14, weight: .light))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(lineWidth: 1)
                                )
                        }
                        .padding(.bottom, 10)
                    }
                    .buttonStyle(ResizableButtonStyle())
                }
            }
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        MainGridTopView(viewModel: MainGridViewModel())
    }
}