//
//  TrailerView.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import SwiftUI
import AVKit

struct TrailerView: View {
    let videoPath: URL
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Watch trailer")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.primary)
            VideoPlayer(player: AVPlayer(url: videoPath))
                .frame(width: Constants.screenWidth * 0.92, height: 250)
                .cornerRadius(10)
        }
    }
}
