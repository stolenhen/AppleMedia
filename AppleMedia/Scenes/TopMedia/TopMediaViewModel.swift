//
//  TopMediaViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import Combine
import Foundation
import Networking

final class TopMediaViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    private var anyCancellable: Set<AnyCancellable> = []
    private var media: [Media] = []
    
    var filteredContent: [Media] {
        switch sortType {
        case .noSorting:
            return mediasResult
        case let .search(searchTerm):
            guard !searchTerm.isEmpty else { return mediasResult }
            return mediasResult.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
        case let .filter(iD):
            return mediasResult.filter { $0.genreName == iD }
        }
    }
    
    var genresResult: [String] {
        Set(mediasResult.map(\.genreName)).sorted()
    }
    
    
    // MARK: - Publishers
    
    @Published private(set) var mediasResult: [Media] = []
    
    @Published var sortType: SortingType = .noSorting
    @Published var searchTerm = ""
    @Published var toDetail: ToDetail?
    @Published var currentGenre: String = ""
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        fetchMedia()
        
        $sortType
            .map { $0 == .search(searchTerm: "") }
            .map { _ in return "" }
            .assign(to: &$currentGenre)
    }
    
    // MARK: - Functions
    
    func select(_ genre: String) {
        sortType = .filter(iD: genre)
        if !searchTerm.isEmpty {
            searchTerm = ""
        }
        currentGenre = genre
    }
    
    func detailWith(media: Media) {
        toDetail = .init(id: media.id, view: DetailView(mediaId: media.id))
    }
}

private extension TopMediaViewModel {
    func fetchMedia() {
        ["i", "e", "s", "a", "b", "n"].forEach { item in
            networkService
                .request(endpoint: .getInfo(by: .search(mediaName: item, country: "")))
                .map { $0 as RootDetail }
                .catch(handleError)
                .map { self.media.append(contentsOf: $0.results.map(Media.init)) }
                .map(handleResult)
                .assign(to: &$mediasResult)
        }
    }
    
    func handleResult() -> [Media] {
        return media.reduce([Media]()) { result, media in
            result.contains(media) ? result : result + [media]
        }
    }
    
    func handleError(_ networkError: NetworkError) -> Empty<RootDetail, Never> {
        // TODO: error handling
        .init()
    }
}
