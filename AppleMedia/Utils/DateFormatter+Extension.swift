//
//  DateFormatter+Extension.swift
//  AppleMedia
//
//  Created by Iashes Ivan on 01.05.2022.
//

import Foundation

extension DateFormatter {
    func configure(_ config: (inout DateFormatter) -> Void) -> DateFormatter {
        var copy: DateFormatter = self
        config(&copy)
        return copy
    }
    
    static var defaultFormatter: DateFormatter {
        .init().configure { $0.dateFormat = "yyyy MMMM dd" }
    }
   
    static var isoFormatter: DateFormatter {
        .init().configure {
            $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            $0.locale = Locale(identifier: "en_US_POSIX")
        }
    }
}
