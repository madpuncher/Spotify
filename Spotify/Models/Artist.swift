//
//  Artist.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

struct Artist: Codable {
    
    let id: String
    let name: String
    let type: String
    let external_urls: [String: String]
}
