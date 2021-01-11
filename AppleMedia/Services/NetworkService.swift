//
//  NetworkService.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//
import Foundation
import Combine

enum ResponseType {
    case feed(country: String)
    case detail(id: String, country: String)
    case search(mediaName: String, country: String)
}

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T?, AppleMediaErrors>
}

final class NetworkService: NetworkServiceProtocol {

    func fetch<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T?, AppleMediaErrors> {
        guard
            let url = endpoint.url else {
            return
                Fail(error: AppleMediaErrors.urlErrors(description: "Invalid URL"))
                .eraseToAnyPublisher()}
        return
            URLSession
            .shared
            .appleMediaPublisher(for: url)
    }
}

extension Endpoint {
    
    static func getInfo(by responseType: ResponseType) -> Endpoint {
       
        switch responseType {
        case let .feed(country):
            return Endpoint(path: "/api/v1/\(country)/movies/top-movies/all/200/explicit.json",
                                     queryItems: [])
            
        case let .detail(id, country):
            return Endpoint(path: "/lookup",
                                     queryItems: [ URLQueryItem(name: "entity", value: "movie"),
                                                   URLQueryItem(name: "country", value: country),
                                                   URLQueryItem(name: "id", value: id) ])
        case let .search(mediaName, country):
            return Endpoint(path: "/search",
                                     queryItems: [ URLQueryItem(name: "entity", value: "movie"),
                                                   URLQueryItem(name: "country", value: country),
                                                   URLQueryItem(name: "term", value: mediaName) ])
        }
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = queryItems.isEmpty ? "rss.itunes.apple.com" : "itunes.apple.com"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
