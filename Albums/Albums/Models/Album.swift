//
//  Album.swift
//  Albums
//
//  Created by Tobi Kuyoro on 09/03/2020.
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
    let name: String
    
    enum SongKeys: String, CodingKey {
        case duration
        case id
        case name
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
