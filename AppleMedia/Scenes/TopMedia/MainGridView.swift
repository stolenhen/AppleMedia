//
//  MainGridView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct MainGridView: View {
    @EnvironmentObject private var userPersonal: Settings
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = MainGridViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            MainGridTopView(viewModel: viewModel)
            Divider()
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: GridMode.flexible(columnsCount: 3, spacing: 10).columns, spacing: 10) {
                    ForEach(viewModel.filteredContent) { media in
                        WebImageView(imagePath: media.posterPath.resizedPath(size: 200))
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 200)
                            .cornerRadius(10)
                            .onTapGesture { viewModel.detailWith(media: media) }
                            .fullScreenCover(item: $viewModel.toDetail) {
                                DetailView(mediaId: $0.id)
                                    .ignoresSafeArea()
                                    .preferredColorScheme(colorScheme == .dark ? .dark : .light)
                                    .environmentObject(userPersonal)
                            }
                    }
                }
            }
            .padding(.horizontal, 5)
            .overlay(loadingView)
        }
        .ignoresSafeArea(edges: .top)
    }
}

private extension MainGridView {
    @ViewBuilder
    var loadingView: some View {
        if viewModel.mediasResult.isEmpty {
            LoadingView()
        }
    }
}

struct MainGridView_Previews: PreviewProvider {
    static var previews: some View {
        MainGridView()
            .environmentObject(Settings())
    }
}
