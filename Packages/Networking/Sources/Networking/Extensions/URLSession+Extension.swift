//
//  URLSession+Extension.swift
//  AppleMedia
//
//  Created by stolenhen on 23.12.2020.
//

import Combine
import Foundation

public extension URLSession {
    static var session: URLSession {
        let session = URLSession(configuration: .default)
        session.configuration.urlCache = .init(memoryCapacity: 0, diskCapacity: 200.toMb)
        return session
    }
    
    func appleMediaPublisher<T: Decodable>(for url: URL, decoder: JSONDecoder = .init()) -> AnyPublisher<T, NetworkError> {
        dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error -> NetworkError in
                switch error {
                case let error as URLError:
                    return NetworkError.urlErrors(description: error.localizedDescription)
                default:
                    return NetworkError.emptyDetailData(country: "Current Country")
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}