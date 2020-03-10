//
//  Album.swift
//  Albums
//
//  Created by Tobi Kuyoro on 09/03/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Album: Codable {
    let artist: String
    let coverArt: [URL]
    let genres: [String]
    let id: String
    let name: String
    let songs: [Song]
    
    enum AlbumKeys: String, CodingKey {
        case artist
        case coverArt
        case genres
        case id
        case name
        case songs
    }
    
    enum CoverArtKeys: String, CodingKey {
        case url
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: AlbumKeys.self)
        var coverArtContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        var urlContainer = coverArtContainer.nestedContainer(keyedBy: CoverArtKeys.self)
        var songsContainer = container.nestedUnkeyedContainer(forKey: .songs)
        
        try container.encode(artist, forKey: .artist)
        
        for url in coverArt {
            try urlContainer.encode(url.absoluteString, forKey: .url)
        }
        
        try container.encode(genres, forKey: .genres)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        for song in songs {
            try songsContainer.encode(song)
        }
        
    }
        
    init(from decoder: Decoder) throws {
        
        // Arrays
        var coverArtURLs: [String] = []
        var genres: [String] = []
        var songs: [Song] = []
        
        // Containers
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        let coverArtContainer = try container.nestedContainer(keyedBy: CoverArtKeys.self, forKey: .coverArt)
        var genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        
        // Properties
        let artist = try container.decode(String.self, forKey: .artist)
        
        let url = try coverArtContainer.decode(String.self, forKey: .url)
        coverArtURLs.append(url)
        
        while !genresContainer.isAtEnd {
            let genreString = try genresContainer.decode(String.self)
            genres.append(genreString)
        }
        
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        while !songsContainer.isAtEnd {
            let song = try songsContainer.decode(Song.self)
            songs.append(song)
        }
        
        self.artist = artist
        self.coverArt = coverArtURLs.compactMap { URL(string: $0) }
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
}

struct Song: Codable {
    let duration: String
    let id: String
    let name: String
    
    enum SongKeys: String, CodingKey {
        case duration
        case id
        case name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SongKeys.self)
        
        try container.encode(duration, forKey: .duration)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKeys.self)
        
        let duration = try container.decode(String.self, forKey: .duration)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        self.duration = duration
        self.id = id
        self.name = name
    }
}
