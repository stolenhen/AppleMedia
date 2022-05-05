//
//  WantToWatchButton.swift
//  AppleMedia
//
//  Created by stolenhen on 25.11.2020.
//

import SwiftUI

struct WantToWatchButton: View {
    @EnvironmentObject private var userPersonal: Settings
    var media: Media?
    
    var body: some View {
        Button(action: wantToWatch) {
            HStack(spacing: 5) {
                Image(systemName: isWanted ? "heart.fill" : "heart")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(.systemPink))
                Text("Want \nto watch")
                    .font(.system(size: 10))
                    .multilineTextAlignment(.leading)
                    .frame(width: 68, alignment: .leading)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
    }
}

private extension WantToWatchButton {
    var isWanted: Bool {
        guard let media = media else { return false }
        return userPersonal.wantToWatch.contains(media)
    }
    
    func wantToWatch() {
        guard let media = media else { return }
        userPersonal.wantToWatchIt(media)
    }
}

struct WantToWatchButton_Previews: PreviewProvider {
    static var previews: some View {
        WantToWatchButton()
    }
}
