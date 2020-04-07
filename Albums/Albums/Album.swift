//
//  Album.swift
//  Albums
//
//  Created by Tobi Kuyoro on 06/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
    var artist: String
    var coverArt: [URL]
    var genres: [String]
    var id: String
    var name: String
    var songs: [Song]
    
    enum AlbumKeys: String, CodingKey {
        case artist
        case covertArt
        case genres
        case id
        case name
        case songs
    }
    
    enum CovertArtKeys: String, CodingKey {
        case url
    }
    
    init(artist: String, coverArt: [URL], genres: [String], id: String, name: String, songs: [Song]) {
        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumKeys.self)
        let coverArtContainer = try container.nestedContainer(keyedBy: CovertArtKeys.self, forKey: .covertArt)
        var genresContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        
        var genresList: [String] = []
        while !genresContainer.isAtEnd {
            let genre = try genresContainer.decode(String.self)
            genresList.append(genre)
        }
        
        artist = try container.decode(String.self, forKey: .artist)
        coverArt = try coverArtContainer.decode([URL].self, forKey: .url)
        genres = genresList
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        songs = try container.decode([Song].self, forKey: .songs)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlbumKeys.self)
        var coverArtContainer = container.nestedContainer(keyedBy: CovertArtKeys.self, forKey: .covertArt)
        var genresContainer = container.nestedUnkeyedContainer(forKey: .genres)
        
        try container.encode(artist, forKey: .artist)
        try coverArtContainer.encode(coverArt, forKey: .url)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(songs, forKey: .songs)
        
        for genre in genres {
            try genresContainer.encode(genre)
        }
    }
}

struct Song: Codable, Equatable {
    let duration: String
    let id: String
    let title: String
    
    enum SongKeys: String, CodingKey {
        case duration
        case id
        case title
    }
    
    enum DurationKeys: String, CodingKey {
        case duration
    }
    
    enum NameKeys: String, CodingKey {
        case title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongKeys.self)
        let durationContainer = try container.nestedContainer(keyedBy: DurationKeys.self, forKey: .duration)
        let nameContainer = try container.nestedContainer(keyedBy: NameKeys.self, forKey: .title)
        
        duration = try durationContainer.decode(String.self, forKey: .duration)
        id = try container.decode(String.self, forKey: .id)
        title = try nameContainer.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SongKeys.self)
        var durationContainer = container.nestedContainer(keyedBy: DurationKeys.self, forKey: .duration)
        var nameContainer = container.nestedContainer(keyedBy: NameKeys.self, forKey: .title)
        
        try durationContainer.encode(duration, forKey: .duration)
        try container.encode(id, forKey: .id)
        try nameContainer.encode(title, forKey: .title)
    }
}
