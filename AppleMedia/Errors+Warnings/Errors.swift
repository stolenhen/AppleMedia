//
//  Errors.swift
//  AppleMedia
//
//  Created by stolenhen on 02.12.2020.
//

import Foundation

enum AppleMediaErrors: Error {
    
    case emptyDetailData(country: String)
    case urlErrors(description: String)
    case noInternetConnection
  
    var localizedDescription: String {
        
        switch self {
        case let .emptyDetailData(country): return
            """
            Unfortunately at this moment Itunes
            has no media data for \(country).
            You will see data for USA automatically.
            """
        case let .urlErrors(description): return description
        case .noInternetConnection: return
            """
            No internet connection
            """
        }
    }
}
