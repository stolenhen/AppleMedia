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
        VStack(alignment: .leading, spacing: 5) {
            
            Color(colorScheme == .light ? .lightMode : .darkMode)
                .frame(height: Constants.screenHeight * 0.1)
            
            ZStack {
                VStack(spacing: 10) {
                    Image(systemName: "globe")
                        .font(.system(size: 50, weight: .ultraLight))
                        .opacity(0.5)
                    Text("Current country is: \(userPersonal.countryName)")
                }
                .foregroundColor(.secondary)
                countryPicker
            }
            
            Spacer()
            
            ForEach(userPersonal.settings) { setting in
                Button(
                    action: {
                        withAnimation { userPersonal.tapped(on: setting)} },
                    label: {
                        HStack(alignment: .firstTextBaseline, spacing: 5) {
                            Image(systemName: setting.icon)
                            Text(setting.title)
                            Spacer() }
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 30).stroke())
                            .font(.title2).foregroundColor(.primary)
                    })
            }
            .disabled(userPersonal.picker)
            .padding(.horizontal)
            
        }
        .ignoresSafeArea(edges: .top)
        .padding(.bottom, 50)
        .onReceive(userPersonal.$isConnected) {
            guard !$0 else { return }
            userPersonal.presenter =
                .alert(.error(description: .noInternetConnection))
        }
        .onDisappear {
            userPersonal.picker = false
        }
    }
    
    var countryPicker: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                
                Text("Select your country:")
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(
                    action: {
                        withAnimation {
                            userPersonal.picker.toggle()
                        }
                    }
                ) {
                    Text("Accept")
                        .font(.title3)
                        .foregroundColor(Color(.systemPink))
                }
            }
            
            TextField("Search country...", text: $userPersonal.countryName)
            
            Divider().padding(.vertical)
            
            Picker("", selection: $userPersonal.countryName) {
                ForEach(userPersonal.countryNames, id: \.self) {
                    Text($0).tag($0)
                }
            }
        }
        .modifier(AlertPresenter(presenter: $userPersonal.presenter))
        .onReceive(userPersonal.$defaultCode) {
            guard $0 else { return }
            userPersonal.presenter = .alert(.error(description: .emptyDetailData(country: userPersonal.countryName))) }
        .padding()
        .background(Image("wall").resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.15))
        .background(Color(colorScheme == .dark ? .darkMode : .lightMode))
        .cornerRadius(20)
        .padding()
        .opacity(userPersonal.picker ? 1 : 0)
        .scaleEffect(userPersonal.picker ? 1 : 0.5)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
