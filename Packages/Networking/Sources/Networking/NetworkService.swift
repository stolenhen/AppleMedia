//
//  NetworkService.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import Foundation
import Combine

public enum ResponseType {
    case detail(id: String)
    case search(mediaName: String, country: String)
}

public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

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

public extension Endpoint {
    static func getInfo(by responseType: ResponseType) -> Endpoint {
        switch responseType {
        case let .detail(id):
            return Endpoint(
                path: "/lookup",
                queryItems: [ URLQueryItem(name: "entity", value: "movie"),
                              URLQueryItem(name: "id", value: id) ]
            )
        case let .search(mediaName, country):
            return Endpoint(
                path: "/search",
                queryItems: [ URLQueryItem(name: "entity", value: "movie"),
                              URLQueryItem(name: "country", value: country),
                              URLQueryItem(name: "term", value: mediaName) ]
            )
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
