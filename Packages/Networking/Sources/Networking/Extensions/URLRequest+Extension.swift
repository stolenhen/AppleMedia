//
//  File.swift
//  
//
//  Created by Iashes Ivan on 06.05.2022.
//

import Foundation

extension URLRequest {
    func print() {
        let url = self.url?.absoluteString ?? ""
        var message = "\(self.httpMethod ?? "???"): \(url)"
        if let data = self.httpBody, let body = String(data: data, encoding: .utf8) {
            message += "\n\tbody: \(body)"
        }
        debugPrint(message)
    }
}
