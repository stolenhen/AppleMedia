//
//  DetailView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = DetailViewModel()
    
    let mediaId: String
    
    var body: some View {
        ZStack {
            if viewModel.detailResults.count > 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.detailResults) { media in
                        ParallaxView(imagePath: media.posterPath)
                            .onTapGesture {
                                dismiss()
                            }
                        VStack(alignment: .center, spacing: 0) {
                            topView(for: media)
                            buttonsView(for: media)
                            InfoView(media: media)
                                .padding(.horizontal)
                            
                            if !viewModel.hasCollection {
                                Divider()
                                    .padding()
                                TrailerView(videoPath: media.trailerLink)
                                Divider()
                                    .padding()
                                DescriptionView(media: media)
                            }
                            
                            if viewModel.hasCollection {
                                Divider()
                                    .padding()
                                DetailCollectionView(viewModel: viewModel)
                                    .padding(.bottom, 120)
                            }
                        }
                        .background(
                            Color(colorScheme == .dark ? .darkMode : .lightMode)
                                .opacity(0.93))
                        .background(
                            Image("wall")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .edgesIgnoringSafeArea(.all))
                    }
                }
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            } else {
                VStack(spacing: 5) {
                    ProgressView()
                    Button(action: { dismiss() }) {
                        Text("Cacnel").foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            }
        }
        .onAppear {
            guard viewModel.detailResults.isEmpty else { return }
            viewModel.fetchDetail(mediaId: mediaId, country: userPersonal.countryName.getCountryCode)
        }
    }
}

private extension DetailView {
    func topView(for media: Media) -> some View {
        HStack(alignment: .top) {
            WebImageView(imagePath: media.posterPath.resizedPath(size: 200))
                .frame(width: 100, height: 150)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(colorScheme == .dark ? .darkMode : .lightMode), lineWidth: 4)
                        .shadow(color: .gray, radius: 2)
                )
                .offset(x: 0, y: -50)
                .padding(.horizontal)
            VStack(alignment: .leading, spacing: 5) {
                Text(media.name)
                    .font(.title3)
                    .foregroundColor(.primary)
                Text(media.artistName)
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding([.top, .horizontal], 10)
    }
    
    func buttonsView(for media: Media) -> some View {
        HStack {
            Link(destination: media.itunesLink) {
                Label("Itunes", systemImage: "applelogo")
                    .padding(.vertical, 2)
                    .padding(.horizontal, 5)
                    .foregroundColor(.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundColor(
                                Color(.systemPink))) }
            Text(media.country)
                .padding(.vertical, 2)
                .padding(.horizontal, 5)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                        .foregroundColor(Color.secondary)
                )
                .foregroundColor(Color.secondary)
                .padding(.leading, 2)
            Spacer()
            WantToWatchButton(media: media)
        }
        .padding([.horizontal, .bottom])
    }
}


struct DescriptionView: View {
    let media: Media
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Description")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            Text(media.description)
                .fontWeight(.light).font(.system(size: 14))
                .foregroundColor(.primary)
                .padding(.bottom)
        }
        .padding(.horizontal)
    }
}


struct InfoView: View {
    let media: Media
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Short information")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            ForEach(media.shortInfo) { mediaType in
                info(for: mediaType)
            }
        }
    }
}

private extension InfoView {
    func info(for type: Media.ShortInfoType) -> some View {
        HStack(spacing: 0) {
            Text(type.rawValue)
                .fontWeight(.light)
                .foregroundColor(.secondary)
            Spacer()
            Text(type.title(for: media))
                .fontWeight(.light)
                .font(.system(size: 14))
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(mediaId: "455832983")
    }
}
