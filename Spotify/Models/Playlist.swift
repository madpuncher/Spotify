//
//  Playlist.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

struct Playlist: Codable {
    
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIIimage]
    let name: String
    let owner: User
}
