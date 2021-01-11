//
//  DataLoader.swift
//  LazyVGridTesting
//
//  Created by stolenhen on 16.12.2020.
//

import UIKit.UIImage
import Combine

typealias ImageLoaderResponse = AnyPublisher<UIImage?, Never>

protocol ImageLoaderProtocol {
    func fetchData(from path: String?) -> ImageLoaderResponse
}

final class ImageLoader: ImageLoaderProtocol {
 
    private static let cache = ImageCache()
    
    func fetchData(from path: String?) -> ImageLoaderResponse {
        
        guard
            let path  = path,
            let url   = URL(string: path)
        else {
            return
                Just(nil)
                .eraseToAnyPublisher() }
        if
            let image = ImageLoader.cache[path] {
            return
                Just(image)
                .subscribe(on: DispatchQueue.global(qos: .userInteractive))
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        return
            URLSession
            .shared
            .dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .utility))
            .map(\.data)
            .map(UIImage.init)
            .handleEvents(receiveOutput: {
                guard let image = $0 else { return }
                ImageLoader.cache[path] = image
            })
            .catch { _ in Just(nil) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Cache

final class ImageCache {
    
    private lazy var cache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 100.toMb
        return cache
    }()
    
    private lazy var decodedCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.totalCostLimit = 100.toMb
        return cache
    }()
    
    private func getImage(for key: String) -> UIImage? {
        
        if
            let decoded = decodedCache.object(forKey: key as NSString) {
            return decoded
        }
        
        if
            let image = cache.object(forKey: key as NSString) {
            let decodedImage = image.decodedImage
            decodedCache.setObject(decodedImage, forKey: key as NSString)
            return decodedImage
        }
        return nil
    }
    
    private func setImage(_ image: UIImage?, for key: String) {
        guard let image = image else { return }
        let decodedImage = image.decodedImage
        cache.setObject(image, forKey: key as NSString)
        decodedCache.setObject(decodedImage, forKey: key as NSString)
    }
    
    subscript(_ key: String) -> UIImage? {
        get { getImage(for: key) }
        set { setImage(newValue, for: key) }
    }
}

