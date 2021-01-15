//
//  ImageView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct WebImageView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @StateObject
    private var viewModel = WebImageViewModel()
    
    var animated: Bool = false
    let imagePath: String
    
    var body: some View {
        
        if animated {
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable() }
                else {
                    Color(.clear)
                }
            }
            .onAppear {
                withAnimation(.easeInOut) {
                    viewModel.appear = true
                }
                viewModel.fetchImage(path: imagePath)
            }
            .opacity(viewModel.appear ? 1.0 : 0.0)
            .scaleEffect(viewModel.appear ? 1.0 : 0.8) }
        
        else {
            ZStack {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable() }
                else {
                    Color(colorScheme == .dark ? .darkMode : .lightMode)
                    ProgressView()
                }
            }
            .onAppear {
                viewModel.fetchImage(path: imagePath)
            }
        }
    }
}
