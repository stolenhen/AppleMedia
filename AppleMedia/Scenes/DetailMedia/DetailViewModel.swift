//
//  DetailViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 23.11.2020.
//

import Combine
import Networking
import SwiftUI

final class DetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    private var anyCancellable: Set<AnyCancellable> = []
    
    // MARK: - Publishers
    
    @Published private(set) var detailResults: [Media] = []
    
    @Published var toDetail: ToDetail?
    @Published var isLoading: Bool = false
    @Published var errorState: ErrorState = .init(isError: false, descriptor: nil)
    @Published var presenter: Presenter? = nil
    
    // MARK: - Init
    
    init(networkService: NetworkService = .init()) {
        self.networkService = networkService
        $detailResults
            .map(\.isEmpty)
            .assign(to: &$isLoading)
    }
    
    // MARK: - Functions
    
    func fetchDetail(mediaId: String) {
        guard detailResults.isEmpty else { return }
        cleanErrorState()
        networkService.request(endpoint: .getInfo(by: .detail(id: mediaId)))
            .compactMap { $0 as RootDetail }
            .catch(handleError)
            .map(\.results)
            .map { $0.map(Media.init) }
            .assign(to: \.detailResults, on: self)
            .store(in: &anyCancellable)
    }
}

private extension DetailViewModel {
    func handleError(_ error: NetworkError) -> Empty<RootDetail, Never> {
        errorState = .init(
            isError: true,
            descriptor: .init(
                title: error.errorTitle,
                description: error.localizedDescription
            )
        )
        return .init()
    }
    
    func cleanErrorState() {
        guard errorState.isError else {
            return
        }
        errorState = .init(isError: false, descriptor: nil)
    }
}

// MARK: - DetailModel wrapper

struct Media: Identifiable, Codable {
    let detailResult: DetailModel
    
    var posterPath: String { detailResult.artworkUrl100 ?? "" }
    var artistName: String { detailResult.artistName ?? "" }
    var genreName: String { detailResult.primaryGenreName ?? "" }
    var description: String { detailResult.longDescription ?? "" }
    var advisory: String { detailResult.contentAdvisoryRating ?? "Unrated" }
    var rentalPrice: String { String(detailResult.trackRentalPrice ?? 0) }
    var currency: String { (" " + (detailResult.currency ?? "No price")) }
    var country: String { detailResult.country ?? "" }
    var movieCount: String { String(detailResult.trackCount ?? 0) }
    var collectionPrice: String { String(detailResult.collectionHdPrice ?? 0) }
    
    var name: String {
        detailResult.name ?? detailResult.trackName ?? detailResult.collectionName ?? "Unknown media"
    }
    
    var releaseDate: String {
        guard let date = DateFormatter.isoFormatter.date(from: detailResult.releaseDate ?? "") else {
            return ""
        }
        return DateFormatter.defaultFormatter.string(from: date)
    }
    
    var duration: String {
        let seconds = (detailResult.trackTimeMillis ?? 0) / 1000
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .short
        return formatter.string(from: TimeInterval(seconds)) ?? "nil"
    }
    
    var itunesLink: URL {
        URL(string: detailResult.trackViewUrl ?? "") ?? URL(string: "https://www.apple.com/404")!
    }
    
    var trailerLink: URL {
        URL(string: detailResult.previewUrl ?? "") ?? Bundle.main.url(forResource: "Placeholder", withExtension: "mov")!
    }
    
    var id: String {
        detailResult.id ?? detailResult.trackId?.description ?? UUID().uuidString
    }
    
    var shortInfo: [ShortInfoType] {
        ShortInfoType.allCases.filter( { $0.title(for: self) != "0" && $0.title(for: self) != "0.0" } )
    }
    
    enum ShortInfoType: String, CaseIterable, Identifiable {
        case advisory = "Advisory rating"
        case genre = "Genre"
        case releaseDate = "Release date"
        case duration = "Duration"
        case rentalPrice = "Movie rental price"
        case moviesInCollection = "Movies in collection"
        case collectionHDPrice = "Collection HD price"
        
        var id: String { rawValue }
        
        func title(for media: Media) -> String {
            switch self {
            case .advisory:
                return media.advisory
            case .genre:
                return media.genreName
            case .releaseDate:
                return media.releaseDate
            case .duration:
                return media.duration
            case .rentalPrice:
                return media.rentalPrice
            case .moviesInCollection:
                return media.movieCount
            case .collectionHDPrice:
                return media.collectionPrice + media.currency
            }
        }
    }
}

extension Media: Equatable, Hashable {
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
