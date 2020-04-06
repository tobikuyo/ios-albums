//
//  Album.swift
//  Albums
//
//  Created by Tobi Kuyoro on 06/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct Album: Decodable {
    let artist: String
    let coverArt: [URL]
    let genres: [String]
    let id: String
    let name: String
    let songs: [Song]
}

struct Song: Decodable {
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
}
