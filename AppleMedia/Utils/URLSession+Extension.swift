//
//  URLSession+Extension.swift
//  AppleMedia
//
//  Created by stolenhen on 23.12.2020.
//

import Combine
import Foundation

extension URLSession {
    
    func appleMediaPublisher<T: Decodable>(for url: URL,
                                           decoder: JSONDecoder = .init()) -> AnyPublisher<T?, AppleMediaErrors> {
        dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .map(\.data)
            .decode(type: T?.self, decoder: decoder)
            .mapError { error -> AppleMediaErrors in
                switch error {
                case
                    let error as URLError:
                    return
                        AppleMediaErrors.urlErrors(description: error.localizedDescription)
                default:
                    return
                        AppleMediaErrors.emptyDetailData(country: "Current Country")
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
