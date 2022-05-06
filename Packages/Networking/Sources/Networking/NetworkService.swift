//
//  NetworkService.swift
//  Networking
//
//  Created by stolenhen on 22.11.2020.
//

import Foundation
import Combine

public protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}

public final class NetworkService: NetworkServiceProtocol {
    
    public init() {}
    
    public func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        return URLSession.session.appleMediaPublisher(for: url)
    }
}

public enum ResponseType {
    case detail(id: String)
    case search(mediaName: String, country: String)
}
