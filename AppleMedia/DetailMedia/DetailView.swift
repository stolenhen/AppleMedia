//
//  DetailView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.presentationMode) private var presentation
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = DetailViewModel()
    
    let mediaId: String
    
    var body: some View {
        
        ZStack {
            if viewModel.detailResults.count > 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(viewModel.detailResults) { media in
                        
                        ParallaxView(imagePath: media.posterPath)
                            .onTapGesture { presentation.wrappedValue.dismiss() }
                        
                        VStack(alignment: .center, spacing: 0) {
                            
                            TopView(media: media).frame(height: 100)
                            
                            ButtonsView(media: media)
                            
                            InfoView(media: media).padding(.horizontal)
                            
                            if !viewModel.hasCollection {
                                Divider().padding()
                                TrailerView(videoPath: media.trailerLink)
                                Divider().padding()
                                DescriptionView(media: media) }
                            
                            if viewModel.hasCollection {
                                Divider().padding()
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
            }
            else {
                VStack(spacing: 5) {
                    ProgressView()
                    Button(action: { presentation.wrappedValue.dismiss() }) {
                        Text("Cacnel").foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
            }
        }
        .onAppear { if viewModel.detailResults.isEmpty {
            viewModel.fetchDetail(mediaId: mediaId,
                                  country: userPersonal.countryName.getCountryCode) }
        }
        .onChange(of: viewModel.defaultCountry) {
            guard $0 else { return }
            viewModel.fetchDetail(mediaId: mediaId, country: userPersonal.defaultCountry)
        }
    }
    
    struct TopView: View {
        
        @Environment(\.colorScheme) private var colorScheme
        
        let media: Media
        
        var body: some View {
            
            HStack(alignment: .top) {
                
                WebImageView(imagePath: media.posterPath.resizedPath(size: 200))
                    .frame(width: 100, height: 150)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(colorScheme == .dark ? .darkMode : .lightMode), lineWidth: 4)
                                .shadow(color: .gray, radius: 2))
                    .offset(x: 0, y: -70)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text(media.name)
                        .font(.title3)
                        .foregroundColor(.primary)
                    
                    Text(media.artistName)
                        .font(.system(size: 16, weight: .light))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .lineLimit(nil)
                .frame(height: 130)
                .padding(.vertical, 10)
                
                Spacer()
            }
            .padding(.top, 50)
        }
    }
    
    struct ButtonsView: View {
        
        let media: Media
        
        var body: some View {
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
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                                    .foregroundColor(Color.secondary))
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 2)
                
                Spacer()
                
                WantToWatchButton(media: media)
            }
            .padding()
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
}

struct InfoView: View {
    
    let media: Media
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text("Short information")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.primary)
                .padding(.bottom, 5)
            
            HStack(spacing: 0) {
                Text("Advisory rating")
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                Spacer()
                Text(media.advisory)
                    .fontWeight(.light)
                    .font(.system(size: 14))
            }
            HStack(spacing: 0) {
                Text("Genre")
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                Spacer()
                Text(media.genreName)
                    .fontWeight(.light)
                    .font(.system(size: 14))
            }
            
            HStack {
                Text("Release date")
                    .fontWeight(.light)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(media.releaseDate, style: .date)
                    .fontWeight(.light)
                    .font(.system(size: 14))
            }
            
            if
                media.duration != "0.0" {
                HStack {
                    Text("Duration")
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(media.duration)
                        .fontWeight(.light)
                        .font(.system(size: 14))
                }
            }
            
            if
                media.rentalPrice != "0.0" {
                HStack {
                    Text("Movie rental price")
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(media.rentalPrice + media.currency)
                        .fontWeight(.light)
                        .font(.system(size: 14))
                }
            }
            
            if
                media.movieCount > "1" {
                HStack {
                    Text("Movies in collection")
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(media.movieCount)
                        .fontWeight(.light)
                        .font(.system(size: 14))
                }
                
                HStack {
                    Text("Collection HD price")
                        .fontWeight(.light)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(media.collectionPrice + media.currency)
                        .fontWeight(.light)
                        .font(.system(size: 14))
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(mediaId: "455832983")
    }
}
