//
//  FeedModel.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import Foundation

struct RootDetail: Decodable {
    let results: [DetailModel]
}

struct DetailModel: Codable {
    let id: String?
    let name: String?
    let currency: String?
    let country: String?
    let trackId: Int?
    let trackTimeMillis: Int?
    let collectionName: String?
    let collectionHdPrice: Double?
    let trackCount: Int?
    let collectionId: Int?
    let artistName: String?
    let trackName: String?
    let longDescription: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackViewUrl: String?
    let releaseDate: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let trackRentalPrice: Double?
}
