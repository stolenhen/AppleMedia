//
//  Storage.swift
//  AppleMedia
//
//  Created by stolenhen on 24.11.2020.
//

import Network
import SwiftUI

final class UserPersonal: ObservableObject {
    
    // MARK: - Properties
    
    @AppStorage("darkMode") private var darkMode = false
    
    @Published var wantToWatch = [Media]()
    @Published var sorting: StorageSortingType = .name
    @Published var defaultCode = false
    @Published var picker = false
    @Published var isConnected = true
    @Published var expand = false
    
    @Published var countryName = "" {
        didSet {
            storeCountry(countryName)
        }
    }
    
    private let monitor = NWPathMonitor()
    private let storage = UserDefaults.standard
    
    let defaultCountry = "US"
    let settings: [SettingItem] =
        [
            SettingItem(title: "Dark / Light", icon: "moon.circle", type: .mode),
            SettingItem(title: "Select Country", icon: "globe", type: .country),
            SettingItem(title: "Empty WantToWatch Storage", icon: "trash.circle", type: .cleanStorage)
        ]
    
    var presenter: Presenter? = .none
    var countryNames: [String] {
        NSLocale
            .isoCountryCodes
            .map { $0.getCountryName }
            .sorted()
    }
    
    //MARK: - Init
    
    init() {
        wantToWatch = getMedia()
        countryName = loadCountry()
        checkConnection()
    }
}


// MARK: - Settings

extension UserPersonal {
    
    func tapped(on: SettingItem) {
        switch on.type {
        case .country: picker.toggle()
        case .mode: darkMode = !darkMode
        case .cleanStorage:
            objectWillChange.send()
            if !wantToWatch.isEmpty {
                presenter = .alert(
                    .warningWithAction(message: "Are you sure you want to permanently erase the medias in the Storage?") { [ weak self ] in
                        guard let self = self else { return }
                        self.wantToWatch.removeAll()
                        self.presenter = .alert(
                            .warning(message: "Done!\n Your Storage is empty")
                        )
                    }
                )
            } else {
                presenter = .alert(
                    .warning(message: "Your Storage is empty")
                )
            }
        }
    }
    
    private func storeCountry(_ country: String) {
        do {
            let encoded = try JSONEncoder().encode(country)
            storage.set(encoded, forKey: MediaKeys.country.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadCountry() -> String {
        guard let data = storage.data(forKey: MediaKeys.country.rawValue)
        else { return "Russia" }
        
        var country: String?
        
        do {
            let string = try JSONDecoder().decode(String.self, from: data)
            country = string
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return country ?? "Russia"
    }
    
    // Does not work with simulators
    private func checkConnection() {
        monitor.pathUpdateHandler = { [ weak self ] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}


// MARK: - Storage

extension UserPersonal {
    
    func isWanted(media: Media) -> Bool {
        wantToWatch.contains(media)
    }
    
    func wantToWatchIt(_ media: Media) {
        objectWillChange.send()
        if wantToWatch.contains(media) {
            for mediaInArray in wantToWatch {
                if mediaInArray.id == media.id {
                    deleteMedia(media)
                    break
                }
            }
        }
        else { wantToWatch.append(media) }
    }
    
    func sorted() {
        switch sorting {
        case .name:  wantToWatch = wantToWatch.sorted(by: { $0.name < $1.name })
        case .date:  wantToWatch = wantToWatch.sorted(by: { $0.releaseDate > $1.releaseDate })
        case .genre: wantToWatch = wantToWatch.sorted(by: { $0.genreName < $1.genreName })
        }
    }
   
    private func deleteMedia(_ media: Media) {
        if let index = self.wantToWatch.firstIndex(of: media) {
            wantToWatch.remove(at: index)
        }
    }
    
    func storeMedia() {
        do {
            let encoded = try PropertyListEncoder().encode(wantToWatch)
            storage.setValue(encoded, forKey: MediaKeys.storage.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func getMedia() -> [Media] {
        guard let data = storage.data(forKey: MediaKeys.storage.rawValue) else {
            return []
        }
        var medias: [Media] = []
        
        do {
            medias = try PropertyListDecoder().decode([Media].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        
        return medias
    }
}

extension UserPersonal {
    private enum MediaKeys: String {
        case country
        case storage
    }
}
