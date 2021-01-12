//
//  SortingRype.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import Foundation

enum SortingType: Equatable {
    case search(searchTerm: String)
    case filter(iD: String)
}

enum StorageSortingType: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case name
    case date = "release date" 
    case genre
}
