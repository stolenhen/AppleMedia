//
//  FeedModel.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import Foundation

struct Root: Codable {
    let feed: FeedModel
}

struct FeedModel: Codable {
    let id: String?
    let country: String?
    let icon: String?
    let results: [DetailModel]
}

struct GenreModel: Codable, Identifiable, Hashable {
    let genreId: String
    let name: String
    var id: String { genreId }
}

struct RootDetail: Decodable {
    let results: [DetailModel]
}

struct DetailModel: Codable {
    let id: String?
    let name: String?
    let genres: [GenreModel]?
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
