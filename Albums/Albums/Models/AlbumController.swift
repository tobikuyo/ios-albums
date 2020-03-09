//
//  AlbumController.swift
//  Albums
//
//  Created by Tobi Kuyoro on 09/03/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

struct AlbumController {
    func testDecodingExampleAlbum() {
        guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json"),
            let data = try? Data(contentsOf: urlPath) else { fatalError() }
        
        do {
            let jsonData = try JSONDecoder().decode(Album.self, from: data)
        } catch {
            NSLog("Error decoding album object: \(error)")
        }
    }
}
