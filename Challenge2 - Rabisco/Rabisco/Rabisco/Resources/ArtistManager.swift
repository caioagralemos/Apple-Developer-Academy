//
//  ArtistManager.swift
//  Rabisco
//
//  Created by Caio on 15/11/25.
//

import Combine
import Foundation

// MARK: - Artist Manager
class ArtistManager: ObservableObject {
    @Published var artists: [Artist] = []
    private let userDefaultsKey = "savedArtists"
    private let maxArtists = 6
    
    init() {
        loadArtists()
    }
    
    var canAddMoreArtists: Bool {
        artists.count < maxArtists
    }
    
    func addArtist(name: String, favoriteTopic: ArtistTopic) {
        guard canAddMoreArtists, !name.isEmpty else { return }
        let newArtist = Artist(name, favoriteTopic: favoriteTopic)
        artists.append(newArtist)
        saveArtists()
    }
    
    func updateArtist(_ artist: Artist, newName: String, newTopic: ArtistTopic) {
        guard let index = artists.firstIndex(where: { $0.id == artist.id }) else { return }
        artists[index].name = newName
        artists[index].favoriteTopic = newTopic
        saveArtists()
    }
    
    func deleteArtist(_ artist: Artist) {
        artists.removeAll { $0.id == artist.id }
        saveArtists()
    }
    
    private func saveArtists() {
        if let encoded = try? JSONEncoder().encode(artists) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadArtists() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([Artist].self, from: data) {
            artists = decoded
        }
    }
}
