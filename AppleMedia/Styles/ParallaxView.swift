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
        GeometryReader {
            if $0.frame(in: .global).minY > -300 {
                WebImageView(imagePath: imagePath.resizedPath(size: 600))
                    .aspectRatio(contentMode: .fill)
                    .offset(y: -$0.frame(in: .global).minY)
                    .frame(
                        width: Constants.screenWidth,
                        height: $0.frame(in: .global).minY > 0
                        ? $0.frame(in: .global).minY + 400
                        : 400)
            }
        }
        .frame(height: 300)
    }
}
