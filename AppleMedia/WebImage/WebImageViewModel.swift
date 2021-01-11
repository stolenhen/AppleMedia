//
//  WebImageViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import Combine
import UIKit.UIImage

final class WebImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var appear = false
    
    private let dataLoader: ImageLoaderProtocol
    private var anyCanncellable = Set<AnyCancellable>()
    
    init(dataLoader: ImageLoaderProtocol = ImageLoader()) {
        self.dataLoader = dataLoader
    }
    
    func fetchImage(path: String) {
        dataLoader
            .fetchData(from: path)
            .assign(to: \.image, on: self)
            .store(in: &anyCanncellable)
    }
}
