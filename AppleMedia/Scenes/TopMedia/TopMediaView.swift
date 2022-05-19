//
//  TopMediaView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct TopMediaView: View {
    @EnvironmentObject private var userPersonal: Settings
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = TopMediaViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            TopMediaTopView(viewModel: viewModel)
            Divider()
            ScrollView(showsIndicators: false) {
                LazyVGrid(
                    columns: GridMode.flexible(columnsCount: 3, spacing: Spacing.normal.value).columns,
                    spacing: Spacing.normal.value
                ) {
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
            .padding(.horizontal, spacing: .half)
            .overlay(loadingView)
        }
        .ignoresSafeArea(edges: .top)
    }
}

private extension TopMediaView {
    @ViewBuilder
    var loadingView: some View {
        if viewModel.mediasResult.isEmpty {
            LoadingView()
        }
    }
}

struct MainGridView_Previews: PreviewProvider {
    static var previews: some View {
        TopMediaView()
            .environmentObject(Settings())
    }
}
