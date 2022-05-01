//
//  DetailCollectionView.swift
//  AppleMedia
//
//  Created by stolenhen on 01.12.2020.
//

import SwiftUI

struct DetailCollectionView: View {
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.colorScheme) private var colorScheme
    @ObservedObject var viewModel: DetailViewModel
   
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("All collection")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.collections) { media in
                        VStack(alignment: .center, spacing: 10) {
                            Text(media.name)
                                .fontWeight(.light).font(.system(size: 14))
                                .frame(width: Constants.screenWidth / 3.2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                                .truncationMode(.middle)
                            WebImageView(imagePath: media.posterPath.resizedPath(size: 200))
                                .aspectRatio(contentMode: .fill)
                                .frame(width: Constants.screenWidth / 3.2, height: 200)
                                .cornerRadius(10)
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
            }
        }
        .padding(.horizontal)
    }
}

struct DetailCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        DetailCollectionView(viewModel: DetailViewModel())
    }
}
