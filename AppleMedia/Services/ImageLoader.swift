//
//  DataLoader.swift
//  LazyVGridTesting
//
//  Created by stolenhen on 16.12.2020.
//

import UIKit
import Combine

protocol ImageLoaderProtocol {
    func fetchImage(from path: String) async throws -> UIImage?
}

final class ImageLoader: ImageLoaderProtocol {
    private let session: URLSession
    private var cache: URLCache? {
        session.configuration.urlCache
    }
    
    init(session: URLSession = .session) {
        self.session = session
    }
    
    func fetchImage(from path: String) async throws -> UIImage? {
        guard let url = URL(string: path) else { return nil }
        let request = URLRequest(url: url)
        
        guard let data = cache?.cachedResponse(for: request)?.data, let image = UIImage(data: data) else {
            return try await loadAndCacheImage(with: request)
        }
        
        return image
    }
    
    private func loadAndCacheImage(with request: URLRequest) async throws -> UIImage? {
        do {
            let (data, response) = try await session.data(for: request)
            guard let response = response as? HTTPURLResponse, 200...300 ~= response.statusCode else { return nil }
            let cachedData = CachedURLResponse(response: response, data: data)
            cache?.storeCachedResponse(cachedData, for: request)
            return UIImage(data: data)
        } catch {
            throw error
        }
    }
}
