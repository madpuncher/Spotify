    //
//  APICaller.swift
//  Spotify
//
//  Created by Eʟᴅᴀʀ Tᴇɴɢɪᴢᴏᴠ on 18.08.2021.
//

import Foundation

final class APICaller {
    
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseURL = "https://api.spotify.com/v1/me"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        
        createRequest(with: URL(string: Constants.baseURL), type: .GET) { request in
            
            URLSession.shared.dataTask(with: request) { data, _, error in
              
                guard
                    let data = data,
                    error == nil else {
                        completion(.failure(APIError.failedToGetData))
                        return
                    }
                
                do {
                    
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                    
                } catch let error {
                    completion(.failure(error))
                }
            }
            .resume()
        }
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            
            guard let APIurl = url else { return }
            
            var request = URLRequest(url: APIurl)
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            completion(request)
        }
    }
}
