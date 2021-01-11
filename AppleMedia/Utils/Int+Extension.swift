//
//  Int+Extension.swift
//  AppleMedia
//
//  Created by stolenhen on 18.12.2020.
//

import Foundation

extension Int {
    
    var toMb: Int {
        let number = self
        return number * 1024 * 1024
    }
}
