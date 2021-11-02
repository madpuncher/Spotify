//
//  NewReleases.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 09.10.2021.
//

import Foundation

struct NewReleases: Codable {
    
    let albums: AlbumResponse
}

struct AlbumResponse: Codable {
    
    let items: [Album]
}

struct Album: Codable {
    
    let name: String
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIIimage]
    let release_date: String
    let total_tracks: Int
    let artists: [Artist]
}

