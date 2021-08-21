//
//  AuthManager.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    struct Constants {
        static let clientId = "bac011e2f0cb4b1686d9e3edaf39df30"
        static let clientSecret = "77a402f8ec0947448daf753bdcb2ae60"
    }
    
    private init() {}
    
    var signInURL: URL? {
        let scope = "user-read-private"
        let redirectURL = "https://www.instagram.com/eldar_tengizov"
        let baseURLHeader = "https://accounts.spotify.com/authorize"
        let string =
            "\(baseURLHeader)?response_type=code&client_id=\(Constants                  .clientId)&scope=\(scope)&redirect_uri=\(redirectURL)&show_dialog=TRUE"
         
        return URL(string: string)
    }
    
    var isSignIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false 
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func refreshAccessToken() {
        //Check GIT work or not 
    }
    
    func cacheToken() {
        
    }
        
}
