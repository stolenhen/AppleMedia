//
//  DetailView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI
import AVKit

struct DetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = DetailViewModel()
    
    let mediaId: String
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                loadingView
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.detailResults) { media in
                        ParallaxView(imagePath: media.posterPath)
                            .onTapGesture {
                                dismiss()
                            }
                        VStack(alignment: .center, spacing: .zero) {
                            topView(for: media)
                            buttonsView(for: media)
                            infoView(for: media)
                            isCollectionView(for: media)
                        }
                        .background(backgroundView)
                    }
                }
                .background(backgroundView)
            }
        }
        .onAppear {
            viewModel.fetchDetail(mediaId: mediaId)
        }
        .errorAlert(errorState: $viewModel.errorState) {
            viewModel.fetchDetail(mediaId: mediaId)
        } cancel: { dismiss() }
    }
}

// MARK: - Subviews

private extension DetailView {
    var loadingView: some View {
        VStack(spacing: 5) {
            ProgressView()
            Button(action: { dismiss() }) {
                Text("Cacnel")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundView)
    }
    
    var backgroundView: some View {
        Image("wall")
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .overlay(
                Color(colorScheme == .dark ? .darkMode : .lightMode)
                    .opacity(0.93)
            )
    }
    
    @ViewBuilder
    func isCollectionView(for media: Media) -> some View {
        Divider()
            .padding()
        trailerView(for: media)
        Divider()
            .padding()
        descriptionView(for: media)
    }
    
    func topView(for media: Media) -> some View {
        HStack(alignment: .top) {
            WebImageView(imagePath: media.posterPath.resizedPath(size: 200))
                .frame(width: 100, height: 150)
                .cornerRadius(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(colorScheme == .dark ? .darkMode : .lightMode), lineWidth: 4)
                        .shadow(color: .gray, radius: 2)
                )
                .offset(y: -50)
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
        .padding([.top, .horizontal], spacing: .normal)
    }
    
    func buttonsView(for media: Media) -> some View {
        HStack {
            Link(destination: media.itunesLink) {
                Label("Itunes", systemImage: "applelogo")
                    .padding(.vertical, 2)
                    .padding(.horizontal, spacing: .half)
                    .foregroundColor(.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                            .foregroundColor(
                                Color(.systemPink))) }
            Text(media.country)
                .padding(.vertical, 2)
                .padding(.horizontal, spacing: .half)
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

    func descriptionView(for media: Media) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Description")
                .detailTitle
            Text(media.description)
                .fontWeight(.light).font(.system(size: 14))
                .foregroundColor(.primary)
                .padding(.bottom)
        }
        .padding(.horizontal)
    }

    func infoView(for media: Media) -> some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Short information")
                .detailTitle
            ForEach(media.shortInfo) { mediaType in
                info(for: mediaType, media: media)
            }
        }
        .padding(.horizontal)
    }

    func info(for type: Media.ShortInfoType, media: Media) -> some View {
        HStack(spacing: .zero) {
            Text(type.rawValue)
                .fontWeight(.light)
                .foregroundColor(.secondary)
            Spacer()
            Text(type.title(for: media))
                .fontWeight(.light)
                .font(.system(size: 14))
        }
    }
    
    func trailerView(for media: Media) -> some View {
        VStack(alignment: .leading) {
            Text("Watch trailer")
                .detailTitle
            VideoPlayer(player: AVPlayer(url: media.trailerLink))
                .frame(width: Constants.screenWidth * 0.92, height: 250)
                .cornerRadius(10)
        }
    }
}

// MARK: - Private extensions

private struct DetailTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .light))
            .foregroundColor(.primary)
            .padding(.bottom, spacing: .half)
    }
}

private extension View {
    var detailTitle: some View {
        modifier(DetailTitle())
    }
}

// MARK: - Preview

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(mediaId: "455832983")
            .preferredColorScheme(.dark)
            .environmentObject(Settings())
    }
}
