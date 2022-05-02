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
    
    private let monitor = NWPathMonitor()
    private let storage = UserDefaults.standard
    
    @AppStorage("darkMode") private var darkMode = false
    
    let settings: [SettingItem] = [
        SettingItem(title: "Dark / Light", icon: "moon.circle", type: .mode),
        SettingItem(title: "Empty WantToWatch Storage", icon: "trash.circle", type: .cleanStorage)
    ]
    
    // MARK: - Publishers
    
    @Published private(set) var wantToWatch: [Media] = []
    @Published private(set) var countryName = "US"
    @Published private(set) var isConnected = true
    
    @Published var expand = false
    @Published var sorting: StorageSortingType = .name
    @Published var presenter: Presenter? = .none

    //MARK: - Init
    
    init() {
        checkConnection()
    }
}

// MARK: - Settings

extension UserPersonal {
    func loadMedia() {
        guard let data = storage.data(forKey: MediaKeys.storage.rawValue) else {
            return
        }
        
        do {
            wantToWatch = try PropertyListDecoder().decode([Media].self, from: data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tapped(on: SettingItem) {
        switch on.type {
        case .mode: darkMode.toggle()
        case .cleanStorage:
            guard !wantToWatch.isEmpty else { return }
            presenter = .alert(
                .warningWithAction(message: "Are you sure you want to permanently erase the medias in the storage?") { [ weak self ] in
                    self?.wantToWatch.removeAll()
                    self?.presenter = .alert(.warning(message: "Done!\n Your Storage is empty") )
                }
            )
        }
    }
}

// MARK: - Storage

extension UserPersonal {
    func isWanted(media: Media) -> Bool {
        wantToWatch.contains(media)
    }
    
    func wantToWatchIt(_ media: Media) {
        guard wantToWatch.contains(media) else {
            wantToWatch.append(media)
            return
        }
        
        guard let media = wantToWatch.first(where: { $0.id == media.id }) else {
            return
        }
        
        deleteMedia(media)
    }
    
    func sort(_ sorting: StorageSortingType) {
        switch sorting {
        case .name:
            wantToWatch.sort(by: { $0.name < $1.name })
        case .date:
            wantToWatch.sort(by: { $0.releaseDate > $1.releaseDate })
        case .genre:
            wantToWatch.sort(by: { $0.genreName < $1.genreName })
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
}

private extension UserPersonal {
    enum MediaKeys: String {
        case storage
    }
    
    func deleteMedia(_ media: Media) {
        guard let index = self.wantToWatch.firstIndex(of: media) else {
           return
        }
        wantToWatch.remove(at: index)
    }
    
    func checkConnection() {
        monitor.pathUpdateHandler = { [ weak self ] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
