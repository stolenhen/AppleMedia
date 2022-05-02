//
//  WantToWatchView.swift
//  AppleMedia
//
//  Created by stolenhen on 24.11.2020.
//

import SwiftUI

struct WantToWatchView: View {
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.colorScheme) private var colorScheme
    @State private var showPopView = false
    @State private var media: Media?
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                Color(colorScheme == .light ? .lightMode : .darkMode)
                    .frame(height: Constants.screenHeight * 0.04)
                
                Picker("", selection: $userPersonal.sorting) {
                    ForEach(StorageSortingType.allCases) {
                        Text($0.rawValue.capitalized)
                            .tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
                Divider()
                ScrollView(showsIndicators: false) {
                    ForEach(userPersonal.wantToWatch) { media in
                        WantItemView(media: media)
                            .onTapGesture {
                                withAnimation {
                                    self.media = media
                                    showPopView = true
                                }
                            }
                    }
                }
                .padding(.horizontal, 5)
                .onChange(of: userPersonal.wantToWatch.count) { _ in
                    userPersonal.storeMedia()
                }
                .onChange(of: userPersonal.sorting) { sorting in
                    guard !userPersonal.wantToWatch.isEmpty else { return }
                    withAnimation {
                        userPersonal.sort(sorting)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .disabled(showPopView)
            .blur(radius: showPopView ? 0.5 : 0)
            .overlay(
                Group {
                    if userPersonal.wantToWatch.isEmpty {
                        Text("Add some movies you want to watch")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            )
            if showPopView, let media = media {
                PopView(media: media, showPopView: $showPopView)
            }
        }
        .onAppear(perform: userPersonal.loadMedia)
        .onDisappear {
            showPopView = false
        }
    }
}

struct WantItemView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let media: Media
    
    var body: some View {
        ZStack(alignment: .trailing) {
            WebImageView(imagePath: media.posterPath.resizedPath(size: 500))
                .aspectRatio(contentMode: .fill)
            VStack {
                HStack(alignment: .center) {
                    Text(media.name)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(.primary)
                        .frame(width: 200, alignment: .leading)
                        .padding(.leading, 10)
                    Spacer()
                    Text(media.genreName)
                        .lineLimit(2)
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.primary)
                        .padding(.trailing, 10)
                }
                .background(Color(colorScheme == .dark ? .darkMode : .lightMode).opacity(0.6))
                Spacer()
            }
            .frame(height: Constants.screenHeight * 0.2)
        }
        .frame(height: Constants.screenHeight * 0.2)
        .contentShape(Rectangle())
        .cornerRadius(10)
    }
}

struct PopView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let media: Media
   
    @Binding var showPopView: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            WebImageView(imagePath: media.posterPath.resizedPath(size: 400))
                .aspectRatio(contentMode: .fill)
                .frame(width: Constants.screenWidth * 0.4, height: Constants.screenHeight * 0.3)
                .cornerRadius(10)
                .shadow(
                    color: Color(colorScheme == .light ? .black : .white).opacity(0.5),
                    radius: 10
                )
                .padding()
                .onTapGesture {
                    showPopView.toggle()
                }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(media.name)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    Text(media.releaseDate)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                Spacer()
                WantToWatchButton(media: media)
            }
            Divider()
                .padding(.horizontal)
            ScrollView(.vertical, showsIndicators: false) {
                Text(media.description)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding([.horizontal, .bottom])
            }
        }
        .frame(width: Constants.screenWidth * 0.8, height: Constants.screenHeight * 0.7)
        .background(
            Image("wall")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(0.15)
        )
        .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
        .cornerRadius(20)
    }
}

struct WantToWatchView_Previews: PreviewProvider {
    static var previews: some View {
        WantToWatchView()
    }
}
