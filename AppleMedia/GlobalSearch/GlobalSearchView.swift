//
//  GlobalSearchView.swift
//  AppleMedia
//
//  Created by stolenhen on 01.12.2020.
//

import SwiftUI

struct GlobalSearchView: View {
    
    @StateObject private var viewModel = GlobalSearchViewModel()
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Color(colorScheme == .light ? .lightMode : .darkMode)
                    .frame(height: Constants.screenHeight * 0.04)
                HStack {
                    StaticSearchView(searchTerm: $viewModel.searchTerm)
                        .onReceive(viewModel.$searchTerm) {
                            if $0 == "" {
                                withAnimation {
                                    viewModel.isSearching = false
                                    viewModel.globalResult.removeAll()
                                }
                            }
                        }
                    
                    Button("Search") {
                        viewModel.isSearching = true
                        if
                            userPersonal.defaultCode {
                            viewModel.search(searchTerm: viewModel.searchTerm,
                                             country: userPersonal.defaultCountry) }
                        else {
                            viewModel.search(searchTerm: viewModel.searchTerm,
                                             country: userPersonal.countryName.getCountryCode)
                        }
                    }
                    .padding(.trailing, 5)
                    .disabled(viewModel.searchValidate)
                }
                .padding(.horizontal, 5)
                .padding(.bottom, 1)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
                
                Divider()
                
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.genresResult, id: \.self) { genre in
                        GenreRow(viewModel: viewModel, genreTitle: genre)
                    }
                }
            }
            .overlay(
                Group {
                    if viewModel.globalResult.isEmpty && !viewModel.isSearching {
                        Text(viewModel.placeholder)
                            .foregroundColor(.secondary)
                            .onReceive(viewModel.$isSearching) {
                                guard !$0 else { return }
                                viewModel.placeholder = "Let's find some interesting stuff :)"
                            }
                    }
                    if viewModel.globalResult.isEmpty && viewModel.isSearching {
                        ProgressView()
                    }
                }
            )
        }
        .ignoresSafeArea(edges: .top)
    }
}


struct GenreRow: View {
    
    @EnvironmentObject var userPersonal: UserPersonal
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: GlobalSearchViewModel
    
    let genreTitle: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(genreTitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 5)
                Spacer()
                Text("Found media: \(viewModel.sortedBy(genre: genreTitle).count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.sortedBy(genre: genreTitle)) { media in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(media.name)
                                .frame(width: 140)
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .foregroundColor(.secondary)
                            WebImageView(imagePath: media.posterPath.resizedPath(size: 200))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 140, height: 190)
                                .cornerRadius(10)
                        }
                        .onTapGesture {
                            viewModel.toDetail = .init(id: media.id,
                                                             view: DetailView(mediaId: media.id))
                        }
                        .fullScreenCover(item: $viewModel.toDetail) {
                            DetailView(mediaId: $0.id)
                                .ignoresSafeArea()
                                .preferredColorScheme(colorScheme == .dark ? .dark : .light)
                                .environmentObject(userPersonal)
                        }
                    }
                }
            }
            Divider()
                .padding(5)
                .foregroundColor(Color(.lightGray))
        }
        .padding(.horizontal, 5)
    }
}

struct GlobalSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalSearchView()
    }
}

