//
//  AlbumController.swift
//  Albums
//
//  Created by Tobi Kuyoro on 06/04/2020.
//  Copyright © 2020 Tobi Kuyoro. All rights reserved.
//

import Foundation

class AlbumController {
    
    // MARK: - Properties
    
    var albums: [Album] = []
    let baseURL = URL(string: "https://albums-2c073.firebaseio.com/")!
    
    typealias CompletionHandler = (Error?) -> Void
    
    // MARK: - Firebase Methods
    
    func getAlbums(completion: @escaping CompletionHandler) {
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching albums from database: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data fetched from Firebase")
                return
            }
            
            do {
                let albumJSON = try JSONDecoder().decode([String: Album].self, from: data).map { $0.value }
                self.albums = albumJSON
            } catch {
                NSLog("Error decoding album data: \(error)")
                completion(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    func put(album: Album, completion: @escaping CompletionHandler) {
        let requestURL = baseURL
            .appendingPathComponent(album.id)
            .appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            let albumData = try JSONEncoder().encode(album)
            request.httpBody = albumData
        } catch {
            NSLog("Error encoding album data: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error PUTting album data in database: \(error)")
                completion(error)
                return
            }
            
            completion(nil)
        }.resume()
    }
    
    // MARK: - Testing Methods
    
    func testDecodingExampleAlbum() {
        let urlPath = Bundle.main.path(forResource: "exampleAlbum", ofType: "json")!
        guard let urlPathURL = URL(string: urlPath) else { return }
        
        do {
            let data = try Data(contentsOf: urlPathURL)
            _ = try JSONDecoder().decode(Album.self, from: data)
        } catch {
            NSLog("Error decoding Album Model: \(error)")
        }
    }
    
    func testEncodingExampleAlbum() {
        let urlPath = Bundle.main.path(forResource: "exampleAlbum", ofType: "json")!
        guard let urlPathURL = URL(string: urlPath) else { return }
        
        do {
            let data = try Data(contentsOf: urlPathURL)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            _ = try encoder.encode(data)
        } catch {
            NSLog("Error encoding Album Model: \(error)")
        }
    }
}
