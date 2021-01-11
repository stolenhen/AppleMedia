//
//  WantToWatchButton.swift
//  AppleMedia
//
//  Created by stolenhen on 25.11.2020.
//

import SwiftUI

struct WantToWatchButton: View {
    
    @EnvironmentObject private var userPersonal: UserPersonal
    
    var media: Media?
    
    private var isWanted: Bool {
        guard let media = media else { return false }
        return userPersonal.wantToWatch.contains(media)
    }
    
    var body: some View {
        
        Button(action: wantToWatch) {
            HStack(spacing: -10) {
                
                Image(systemName: isWanted ? "heart.fill" : "heart")
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(.systemPink))
                
                Text("Want \nto watch")
                    .font(.system(size: 10))
                    .frame(width: 68, alignment: .center)
                    .foregroundColor(Color(.secondaryLabel))
            }
        }
    }
    
    private func wantToWatch() {
        guard let media = media else { return }
        userPersonal.wantToWatchIt(media)
    }
}

struct WantToWatchButton_Previews: PreviewProvider {
    static var previews: some View {
        WantToWatchButton()
    }
}
