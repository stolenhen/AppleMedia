//
//  GlobalSearchView.swift
//  AppleMedia
//
//  Created by stolenhen on 01.12.2020.
//

import SwiftUI

struct GlobalSearchView: View {
    @StateObject private var viewModel = GlobalSearchViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: .zero) {
            SearchView(searchQuery: $viewModel.searchQuery)
                .padding(.top, Constants.screenHeight * 0.04)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            Divider()
                .padding(.top, spacing: .half)
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(viewModel.genresResult, id: \.self) { genre in
                    GenreRow(viewModel: viewModel, genreTitle: genre)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .overlay(searchingStateView)
    }
}

private extension GlobalSearchView {
    var searchingStateView: some View {
        Group {
            if viewModel.isSearching {
                LoadingView()
            } else if viewModel.isEmptyQuery {
                Text("Let's find some interesting stuff :)")
            } else if viewModel.nothingFound {
                Text(viewModel.nothingFoundTitle)
            }
        }
        .foregroundColor(.secondary)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(alignment: .center, spacing: Spacing.half.value) {
            Text("Loading...")
                .font(.system(size: 14))
            ProgressView()
        }
    }
}

struct GenreRow: View {
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: GlobalSearchViewModel
    
    let genreTitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.half.value) {
            HStack {
                Text(genreTitle)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, spacing: .half)
                Spacer()
                Text("Found media: \(viewModel.sortedBy(genre: genreTitle).count)")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.secondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.sortedBy(genre: genreTitle)) { media in
                        VStack(alignment: .leading, spacing: Spacing.half.value) {
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
                            viewModel.toDetail = .init(id: media.id, view: DetailView(mediaId: media.id))
                        }
                        .fullScreenCover(item: $viewModel.toDetail) {
                            DetailView(mediaId: $0.id)
                                .ignoresSafeArea()
                                .preferredColorScheme(colorScheme == .dark ? .dark : .light)
                        }
                    }
                }
            }
            Divider()
                .padding(spacing: .half)
                .foregroundColor(Color(.lightGray))
        }
        .padding(.horizontal, spacing: .half)
    }
}

struct GlobalSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalSearchView()
            .preferredColorScheme(.dark)
    }
}

