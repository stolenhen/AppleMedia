//
//  MainGreedViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 22.11.2020.
//

import Combine
import Foundation

final class MainGridViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published
    private(set) var mediasResult: [Media] = []
    
    @Published var defaultCountry = false
    @Published var sortType: SortingType? = nil
    @Published var searchTerm = ""
    @Published var toDetail: ToDetail? = nil
    
    private let networkService: NetworkServiceProtocol
    private var anyCancellable = Set<AnyCancellable>()
    
    var filteredContent: [Media] {
        let filteredArray = mediasResult
        
        switch sortType {
        case let .search(searchTerm):
            guard
                searchTerm != ""
            else { return filteredArray }
            return
                filteredArray
                .filter {
                    $0.name
                        .lowercased()
                        .contains(searchTerm
                                    .lowercased()) }
        case let .filter(iD):
            return filteredArray
                .filter { $0.genre
                    .first?
                    .genreId
                    .contains(iD) ?? false }
        default:
            return filteredArray
        }
    }
    
    var genresResult: [GenreModel] {
        var genres: [GenreModel] = []
        self.mediasResult
            .map(\.genre)
            .forEach {
                genres
                    .append($0.first ?? GenreModel(genreId: "Unknown ID",
                                                   name: "Unknown genre")) }
        return
            Set(genres).sorted(by: { $0.name < $1.name })
    }
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Functions
    
    func fetchMedia(country: String) {
        networkService
            .fetch(endpoint: .getInfo(by: .feed(country: country)))
            .map { $0 as Root? }
            .sink(
                receiveCompletion: { [self] in
                    switch $0 {
                    case .finished: defaultCountry = false
                    case .failure:  defaultCountry = true
                    }
                },
                receiveValue: { [self] in
                    guard let root = $0 else { return }
                    mediasResult = root.feed.results.map(Media.init)
                }
            )
            .store(in: &anyCancellable)
    }
}
