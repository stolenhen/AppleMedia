//
//  ParallaxView.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import SwiftUI

struct ParallaxView: View {
    let imagePath: String
    
    var body: some View {
        GeometryReader { proxy in
            if proxy.frame(in: .global).minY > -300 {
                WebImageView(imagePath: imagePath.resizedPath(size: 600))
                    .scaledToFill()
                    .offset(y: -proxy.frame(in: .global).minY)
                    .frame(width: Constants.screenWidth, height: parallaxHeight(proxy: proxy))
            }
        }
        .frame(height: 300)
    }
}

private extension ParallaxView {
    func parallaxHeight(proxy: GeometryProxy) -> CGFloat {
        proxy.frame(in: .global).minY > 0 ? proxy.frame(in: .global).minY + 400 : 400
    }
}
