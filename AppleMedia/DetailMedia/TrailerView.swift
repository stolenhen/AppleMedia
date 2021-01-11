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
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Watch trailer")
                .font(.system(size: 20, weight: .light))
                .foregroundColor(.primary)
                .padding(.bottom, 10)
            
            PlayerView(videoPath: videoPath)
                .frame(width: Constants.screenWidth * 0.92, height: 250)
                .cornerRadius(10)
        }
    }
}

struct PlayerView: UIViewControllerRepresentable {
    
    let videoPath: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerView>) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: videoPath)
        playerController.player = player
        return playerController
    }
    
    func updateUIViewController(
        _ uiViewController: PlayerView.UIViewControllerType,
        context: UIViewControllerRepresentableContext<PlayerView>) {}
}
