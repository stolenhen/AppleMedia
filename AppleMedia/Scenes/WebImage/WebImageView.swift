//
//  ImageView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct WebImageView: View {
    @StateObject private var viewModel = WebImageViewModel()
    @Environment(\.colorScheme) private var colorScheme
    
    let imagePath: String
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color(colorScheme == .dark ? .darkMode : .lightMode)
                ProgressView()
            }
        }
        .onAppear {
            Task {
               await viewModel.fetchImage(from: imagePath)
            }
        }
    }
}

