//
//  GlobalSearchViewModel.swift
//  AppleMedia
//
//  Created by stolenhen on 01.12.2020.
//

import Combine

final class GlobalSearchViewModel: ObservableObject {
   
    // MARK: - Properties
    
    @Published var presenter: Presenter? = .none
    @Published var searchTerm = ""
    @Published var globalResult: [Media] = []
    @Published var toDetail: ToDetail? = nil
    @Published var isSearching = false 
    
    private let networkService: NetworkServiceProtocol
    private var anyCancellable = Set<AnyCancellable>()
    
    var placeholder = "Let's find some interesting stuff :)"
    
    var searchValidate: Bool {
        searchTerm.count < 2 || searchTerm.first == " "
    }
    
    var genresResult: [String] {
        var genres: [String] = []
        self.globalResult
            .map(\.genreName)
            .forEach { genres.append($0) }
        return
            Set(genres).sorted(by: { $0 < $1 })
    }
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Functions
    
    func sortedBy(genre: String) -> [Media] {
        let medias = globalResult
        return medias.filter { $0.genreName == genre }
    }
    
    func search(searchTerm: String, country: String) {
        networkService
            .fetch(endpoint: .getInfo(by: .search(mediaName: searchTerm, country: country)))
            .map { $0 as RootDetail? }
            .sink(
                receiveCompletion: { [self] in
                    switch $0 {
                    case .finished: break
                    case let .failure(error):
                        objectWillChange.send()
                        presenter = .alert(
                            .error(description: .urlErrors(description: error.localizedDescription)
                            )
                        )
                    }
                },
                receiveValue: { [self] in
                    guard let result = $0 else { return }
                    if result.results.isEmpty {
                        isSearching = false
                        placeholder = "No results for: " + searchTerm }
                    globalResult = result.results.map(Media.init)
                }
            )
            .store(in: &anyCancellable)
    }
}
