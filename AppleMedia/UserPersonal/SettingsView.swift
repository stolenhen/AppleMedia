//
//  Settings.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack(spacing: .zero) {
            Color(colorScheme == .light ? .lightMode : .darkMode)
                .frame(height: 50)
            Spacer()
            ForEach(userPersonal.settings) { setting in
                settingsButton(setting)
            }
        }
        .modifier(AlertPresenter(presenter: $userPersonal.presenter))
        .padding([.horizontal, .bottom])
        .onReceive(userPersonal.$isConnected) {
            guard !$0 else { return }
            userPersonal.presenter = .alert(.error(description: .noInternetConnection))
        }
    }
}

private extension SettingsView {
    func settingsButton(_ setting: SettingItem) -> some View {
        Button(action: {
                withAnimation {
                    userPersonal.tapped(on: setting)
                }
            }, label: {
                HStack {
                    Image(systemName: setting.icon)
                    Text(setting.title)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 30).stroke())
                .font(.title2).foregroundColor(.primary)
                .opacity(setting.type == .cleanStorage && userPersonal.wantToWatch.isEmpty ? 0.5 : 1)
            }
        )
            .padding(.bottom, 10)
            .disabled(setting.type == .cleanStorage ? userPersonal.wantToWatch.isEmpty : false)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
