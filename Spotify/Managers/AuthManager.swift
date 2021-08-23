//
//  AuthManager.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    
    private var refreshingToken = false
    
    struct Constants {
        static let clientId = "bac011e2f0cb4b1686d9e3edaf39df30"
        static let clientSecret = "77a402f8ec0947448daf753bdcb2ae60"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURL = "https://www.instagram.com/eldar_tengizov"
        static let scope = "user-read-private%20playlist-modify-public%20playlist-read-private%20playlist-modify-private%20user-follow-read%20user-library-modify%20user-library-read%20user-read-email"

    }
    
    private init() {}
    
    var signInURL: URL? {
        let baseURLHeader = "https://accounts.spotify.com/authorize"
        let string =
            "\(baseURLHeader)?response_type=code&client_id=\(Constants                  .clientId)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirectURL)&show_dialog=TRUE"
         
        return URL(string: string)
    }
    
    var isSignIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expires_in") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        let currentDate = Date()
        let fiveMinutes: TimeInterval = 300
        return currentDate.addingTimeInterval(fiveMinutes) >= expirationDate
    }
    
    func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURL),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else { completion(false); return }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let results = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.cacheToken(result: results)
                completion(true)

            } catch let error {
                completion(false)
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    private var onRefreshBlocks = [((String) -> Void)]()
    
    func withValidToken(completion: @escaping (String) -> Void) {
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            refreshIfNeeded { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
        } else if let token = accessToken {
            completion(token)
        }
        
    }
    
    func refreshIfNeeded(completion: @escaping (Bool) -> Void) {
        
        guard !refreshingToken else { return }
        
        guard shouldRefreshToken else {
            completion(true)
            return
        }
        
        guard let refreshToken = refreshToken else { return }
        
        guard let url = URL(string: Constants.tokenAPIURL) else { return }
        
        refreshingToken = true
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        
        let basicToken = Constants.clientId + ":" + Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else { completion(false); return }
        
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
                
        URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            
            self?.refreshingToken = false
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let results = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach { $0(results.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: results)
                completion(true)

            } catch let error {
                completion(false)
                print(error.localizedDescription)
            }
        }
        .resume()
    }
    
    func cacheToken(result: AuthResponse) {
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expires_in")

    }
        
}
