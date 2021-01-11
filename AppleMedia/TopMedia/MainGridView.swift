//
//  MainGridView.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import SwiftUI


struct MainGridView: View {
    
    @EnvironmentObject private var userPersonal: UserPersonal
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = MainGridViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            MainGridTopView(viewModel: viewModel)
            
            Divider()
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: GridMode.flexible(columnsCount: 3, spacing: 10).columns, spacing: 10) {
                    
                    ForEach(viewModel.filteredContent) { media in
                        WebImageView(animated: true, imagePath: media.posterPath)
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 50, maxWidth: .infinity, minHeight: 200)
                            .cornerRadius(10)
                            .onTapGesture {
                                viewModel.toDetail = .init(id: media.id,
                                                           view: DetailView(mediaId: media.id))
                            }
                            .fullScreenCover(item: $viewModel.toDetail) {
                                DetailView(mediaId: $0.id)
                                    .ignoresSafeArea()
                                    .preferredColorScheme(colorScheme == .dark ? .dark : .light)
                                    .environmentObject(userPersonal)
                            }
                    }
                }
            }
            .padding(.horizontal, 5)
            .overlay(
                Group {
                    if
                        viewModel.mediasResult.isEmpty {
                        VStack(alignment: .center, spacing: 5) {
                            
                            Text("Loading...")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            ProgressView()
                        }
                    }
                }
            )
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            guard viewModel.mediasResult.isEmpty else { return }
            viewModel.fetchMedia(country: userPersonal.countryName.getCountryCode)
        }
        .onChange(of: userPersonal.picker) {
            guard !$0 else { return }
            userPersonal.defaultCode = false
            viewModel.fetchMedia(country: userPersonal.countryName.getCountryCode)
        }
        .onChange(of: viewModel.defaultCountry) {
            guard $0 else { return }
            userPersonal.defaultCode = true
            viewModel.fetchMedia(country: userPersonal.defaultCountry)
        }
    }
}

struct MainGridView_Previews: PreviewProvider {
    static var previews: some View {
        MainGridView()
            .environmentObject(UserPersonal())
    }
}
