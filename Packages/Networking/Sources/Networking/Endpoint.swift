//
//  Endpoint.swift
//  Networking
//
//  Created by Iashes Ivan on 06.05.2022.
//

import Foundation

public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
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
