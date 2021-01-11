//
//  String+Extension.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import Foundation

extension String {
    
    func resizedPath(size: Int) -> String {
        let string = self
        let resize = string
            .replacingOccurrences(of: "100x100", with: "\(size)x\(size)")
        return resize
    }
    
    var getCountryName: String {
        let code = self
        return NSLocale(localeIdentifier: NSLocale.current.identifier)
            .displayName(forKey: .countryCode, value: code) ?? "Unknown Country" }
    
    var getCountryFlag: String {
        let code = self
        let base: UInt32 = 127397
        var flag = ""
        for v in code.unicodeScalars {
            flag.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(flag)
    }
    
    var getCountryCode: String {
        let name = self
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: "US")
            let countryName = identifier.displayName(forKey: .countryCode, value: localeCode)
            if name.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return "RU"
    }
}
