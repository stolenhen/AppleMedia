//
//  URLRequest+Extension.swift
//  Networking
//
//  Created by Iashes Ivan on 06.05.2022.
//

import Foundation

extension URLRequest {
    func print() {
        let url = url?.absoluteString ?? ""
        var message = "\(httpMethod ?? "???"): \(url)"
        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            message += "\n\tbody: \(body)"
        }
        debugPrint(message)
    }
}
