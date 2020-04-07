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
    
    func getAlbums(completion: @escaping CompletionHandler = { _ in }) {
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
    
    func put(album: Album, completion: @escaping CompletionHandler = { _ in }) {
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
    
    func createAlbum(called name: String, by artist: String, songs: [Song], genres: [String], coverArt: [URL], id: String) {
        let album = Album(artist: artist, coverArt: coverArt, genres: genres, id: id, name: name, songs: songs)
        albums.append(album)
        put(album: album)
    }
    
    func update(album: Album, called name: String, by artist: String, songs: [Song], genres: [String], coverArt: [URL], id: String) {
        guard let index = albums.firstIndex(of: album) else { return }
        var updatedAlbum = album
        
        updatedAlbum.name = name
        updatedAlbum.artist = artist
        updatedAlbum.songs = songs
        updatedAlbum.genres = genres
        updatedAlbum.coverArt = coverArt
        updatedAlbum.id = id
        
        albums[index] = updatedAlbum
        put(album: updatedAlbum)
    }
    
    // MARK: - Testing Methods
    
    func testDecodingExampleAlbum() {
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: urlPath)
            let album = try JSONDecoder().decode(Album.self, from: data)
            print(album)
        } catch {
            NSLog("Error decoding Album Model: \(error)")
        }
    }
    
    func testEncodingExampleAlbum() {
        let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json")!
        
        do {
            let data = try Data(contentsOf: urlPath)
            let album = try JSONEncoder().encode(data)
            let albumString = String(data: album, encoding: .utf8)
            print(albumString)
        } catch {
            NSLog("Error encoding Album Model: \(error)")
        }
    }
}
