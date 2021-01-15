//
//  DetailViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var defaultCountry = false
    @Published var toDetail: ToDetail? = nil
    
    @Published
    private(set) var detailResults: [Media] = []
    private(set) var collections: [Media] = []
    
    private let networkService: NetworkServiceProtocol
    private var anyCancellable = Set<AnyCancellable>()

    var hasCollection: Bool { collections.count >= 1 }
    
    // MARK: - Init
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Functions
    
    func fetchDetail(mediaId: String, country: String) {
       
        networkService.fetch(endpoint: .getInfo(by: .detail(id: mediaId, country: country)))
            .map { $0 as RootDetail? }
            .sink(
                receiveCompletion: {
                    switch $0 { 
                    case .finished: break
                    case let .failure(error): print(error.localizedDescription)
                    } },
                receiveValue: { [self] in
                    guard
                        let root = $0, !root.results.isEmpty
                    else {
                        defaultCountry.toggle()
                        return
                    }
                    setupCollection(result: root.results.map(Media.init)) })
            .store(in: &anyCancellable)
    }
}

extension DetailViewModel {
    
    private func setupCollection(result: [Media]) {
        var resultForCorrectiong = result
        collections = Array(resultForCorrectiong.dropFirst())
        detailResults = resultForCorrectiong.count == 1
            ? resultForCorrectiong
            : Array(arrayLiteral: resultForCorrectiong.removeFirst())
    }
}

// MARK: - DetailModel wrapper

struct Media: Identifiable, Codable {
    
    let detailResult: DetailModel
    
    var posterPath:  String { detailResult.artworkUrl100 ?? "" }
    var artistName:  String { detailResult.artistName ?? ""}
    var genreName:   String { detailResult.primaryGenreName ?? "" }
    var description: String { detailResult.longDescription ?? "" }
    var advisory:    String { detailResult.contentAdvisoryRating ?? "Unrated" }
    var rentalPrice: String { String(detailResult.trackRentalPrice ?? 0) }
    var currency:    String { (" " + (detailResult.currency ?? "No price")) }
    var country:     String { detailResult.country ?? ""}
    var movieCount:  String { String(detailResult.trackCount ?? 0) }
    
    var collectionPrice: String { String(detailResult.collectionHdPrice ?? 0) }
    var genre: [GenreModel] { detailResult.genres ?? [] }
    
    var name: String {
        detailResult.name
            ?? detailResult.trackName
            ?? detailResult.collectionName
            ?? "Unknown media"
    }
    
    var releaseDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: detailResult.releaseDate ?? "") ?? Date()
    }
    
    var duration: String {
        let seconds = (detailResult.trackTimeMillis ?? 0) / 1000
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter.string(from: TimeInterval(seconds)) ?? "nil"
    }
    
    var itunesLink: URL {
        URL(string: detailResult.trackViewUrl ?? "")
            ?? URL(string: "https://www.apple.com/404")! }
    
    var trailerLink: URL {
        URL(string: detailResult.previewUrl ?? "")
            ?? Bundle.main.url(forResource: "Placeholder", withExtension: "mov")! }
    
    var id: String {
        detailResult.id
            ?? detailResult.trackId?.description
            ?? detailResult.collectionId?.description
            ?? UUID().uuidString }
}

extension Media: Equatable, Hashable {
    
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
