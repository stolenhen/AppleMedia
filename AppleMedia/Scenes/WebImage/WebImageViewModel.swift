//
//  WebImageViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import UIKit
import Networking

@MainActor
final class WebImageViewModel: ObservableObject {
    private let dataLoader: ImageLoaderProtocol
    
    @Published private(set) var image: UIImage?
    
    init(dataLoader: ImageLoaderProtocol = ImageLoader()) {
        self.dataLoader = dataLoader
    }

    func fetchImage(from path: String) async {
       image = try? await dataLoader.fetchImage(from: path)
    }
}
