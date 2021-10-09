//
//  FeaturedPlaylist.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 09.10.2021.
//

import Foundation

struct FeaturedPlaylists: Codable {
    
    let playlists: [PlaylistResponse]
}

struct PlaylistResponse: Codable {
    
    let items: [Playlist]
}


struct User: Codable {
    
    let display_name: String
    let external_urls: [String: String]
    let id: String
}
