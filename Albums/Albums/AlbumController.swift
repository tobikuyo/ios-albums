//
//  AlbumController.swift
//  Albums
//
//  Created by Tobi Kuyoro on 06/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

class AlbumController {
    
    func testDecodingExampleAlbum() {
        let urlPath = Bundle.main.path(forResource: "exampleAlbum", ofType: "json")!
        guard let urlPathURL = URL(string: urlPath) else { return }
        
        do {
            let data = try Data(contentsOf: urlPathURL)
            let album = try JSONDecoder().decode(Album.self, from: data)
        } catch {
            NSLog("Error decoding Album Model: \(error)")
        }
    }
}
