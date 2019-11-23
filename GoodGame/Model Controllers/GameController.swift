//
//  GameController.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct GameController {
    // MARK: - Shared Instance
    
    static let shared = GameController()
    
    // MARK: -  Search By Game Name
    
    func searchByGameName(_ gameName: String,
                          completion: @escaping(_ Games: [Game]) -> Void) {
        let requestBodyString = "search " + #""\#(gameName)""# + "; fields name, id, cover, alternative_names, genres, game_modes, platforms, summary, url;"
        guard let requestURL = URL(string: Keys.baseURL + "games"),  let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestURL,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBody) { (data, error) in
            if error != nil {
                print("Error Decoding into Game Array", error?.localizedDescription, error)
                completion([])
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    let games = try jsonDecoder.decode([Game].self, from: recievedData)
                    completion(games)
                    return
                } catch {
                    print(error.localizedDescription, error)
                    completion([])
                }
            }
        }
    }
    
    // MARK: - Get Cover Art Data
    
    func getCoverArtworkByGameId(_ gameId: Int,
                                 completion: @escaping(_ artwork: [Artwork]) -> Void) {
        let requestBodyString = "fields *; exclude image_id; where game = \(gameId);"
        guard let requestURL = URL(string: Keys.baseURL + "covers"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestURL,
                                                httpMethod: .post,
                                                urlParameters: nil,
                                                body: requestBody) { (data, error) in
           if error != nil {
               print(error?.localizedDescription, error)
               completion([])
           } else {
               guard let recievedData = data else {
                   completion([])
                   return
               }
               let jsonDecoder = JSONDecoder()
               do {
                   let artworks = try jsonDecoder.decode([Artwork].self, from: recievedData)
                   completion(artworks)
                   return
               } catch {
                   print("Error Decoding into Artwork", error.localizedDescription, error)
                   completion([])
               }
            }
        }
    }
    
    func getCoverImageByGameId(_ imageId: Int,
                               completion: @escaping(_ coverArt: UIImage?) -> Void) {
        getCoverArtworkByGameId(imageId) { (artworks) in
            guard let imageUrlString = artworks[0].url else { return }
            guard let imageUrl = URL(string:"https:" + imageUrlString) else { return }
            NetworkController.performRequest(for: imageUrl,
                                             httpMethod: .get,
                                             urlParameters: nil,
                                             body: nil) { (data, error) in
                if error != nil {
                    print(error?.localizedDescription, error)
                    completion(nil)
                } else {
                    guard let recievedData = data else {
                        completion(nil)
                        return
                    }
                    completion(UIImage(data: recievedData as Data))
                }
            }
        }
    }
    
    func getCoverImageByArtworks(_ artworks: [Artwork],
                                  completion: @escaping(_ coverArt: UIImage?) -> Void) {
        if artworks.count < 1 {
            completion(nil)
            return
        } else {
            guard let imageUrlString = artworks[0].url else { return }
            guard let imageUrl = URL(string:"https:" + imageUrlString) else { return }
            NetworkController.performRequest(for: imageUrl,
                                                 httpMethod: .get,
                                                 urlParameters: nil,
                                                 body: nil) { (data, error) in
                if error != nil {
                    print(error?.localizedDescription as Any, error as Any)
                    completion(nil)
                } else {
                    guard let recievedData = data else {
                        completion(nil)
                        return
                    }
                    completion(UIImage(data: recievedData as Data))
                }
            }
        }
    }
    
    // MARK: - Get Genre Data
    
    func getGenreByGenreId(_ genreId: Int,
                           completion: @escaping(_ genres: [Genre]) -> Void) {
        let requestBodyString = "fields name; where id = \(genreId);"
        guard let requestUrl = URL(string: Keys.baseURL + "genres"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestUrl,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBody) { (data, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let genres = try decoder.decode([Genre].self, from: recievedData)
                    completion(genres)
                    return
                } catch {
                    print("Error parsing data into genre object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
    }
    
    func getGenresByGenreIds(_ genreIds: [Int],
                          completion: @escaping(_ genres: [Genre]) -> Void) {
        var idArrayString = "("
        var index = 0
        for id in genreIds {
           if index < genreIds.count - 1 {
               idArrayString.append("\(id),")
           } else {
               idArrayString.append("\(id))")
           }
           index += 1
        }
        let requestBodyString = "fields name; where id = \(idArrayString);"
        guard let requestUrl = URL(string: Keys.baseURL + "genres"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestUrl,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBody) { (data, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let genres = try decoder.decode([Genre].self, from: recievedData)
                    completion(genres)
                    return
                } catch {
                    print("Error parsing data into genre object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
    }
    
    // MARK: - Get Platform Data
    
    func getPlatformByPlatformId(_ platformId: Int,
                             completion: @escaping(_ platforms: [Platform]) -> Void) {
        let requestBodyString = "fields *; exclude created_at, product_family, slug, summary, updated_at, versions, websites; where id = \(platformId);"
        guard let requestUrl = URL(string: Keys.baseURL + "platforms"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestUrl,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBody) { (data, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            }
            guard let retreivedData = data else { return }
            let decoder = JSONDecoder()
            do {
                let platforms = try decoder.decode([Platform].self, from: retreivedData)
                completion(platforms)
                return
            } catch {
                print("Error Parsing Platform into Object", error, error.localizedDescription)
                completion([])
                return
            }
        }
    }
    
    func getPlatformsByPlatformIds(_ platformIds: [Int],
                             completion: @escaping(_ platforms: [Platform]) -> Void) {
        var idArrayString = "("
        var index = 0
        for id in platformIds {
           if index < platformIds.count - 1 {
               idArrayString.append("\(id),")
           } else {
               idArrayString.append("\(id))")
           }
           index += 1
        }
        let requestBodyString = "fields *; exclude created_at, product_family, slug, summary, updated_at, versions, websites; where id = \(idArrayString);"
        guard let requestUrl = URL(string: Keys.baseURL + "platforms"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestUrl,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBody) { (data, error) in
            if error != nil {
                print(error, error?.localizedDescription)
                completion([])
                return
            }
            guard let retreivedData = data else { return }
            let decoder = JSONDecoder()
            do {
                let platforms = try decoder.decode([Platform].self, from: retreivedData)
                completion(platforms)
                return
            } catch {
                print("Error Parsing Platform into Object", error, error.localizedDescription)
                completion([])
                return
            }
        }
    }
    
    // MARK: - Get Muliplayer Mode Data
    
    func getMultiplayerModesByModeId(_ multiPlayermodeId: Int,
                                     completion: @escaping(_ mModes: [MultiplayerModes]) -> Void) {
        
    }
    
    // MARK: - Get Game Mode Data
    
    func getGameModesByModeId(_ gameModeId: Int,
                              completion: @escaping(_ gameModes: [GameMode]) -> Void) {
        let requestBodyString = "fields name; where id = \(gameModeId);"
        guard let requestUrl = URL(string: Keys.baseURL + "game_modes"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestUrl,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBody) { (data, error) in
            if error != nil {
                print(error,error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let gameModes = try decoder.decode([GameMode].self, from: recievedData)
                    completion(gameModes)
                    return
                } catch {
                    print("error parsing data into gameMode object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
    }
    
    func getGameModesByModeIds(_ gameModeIds: [Int],
                               completion: @escaping(_ gameModes: [GameMode]) -> Void) {
        var idArrayString = "("
        var index = 0
        for id in gameModeIds {
            if index < gameModeIds.count - 1 {
                idArrayString.append("\(id),")
            } else {
                idArrayString.append("\(id))")
            }
            index += 1
        }
        let requestBodyString = "fields name; where id = \(idArrayString);"
        
        guard let requestUrl = URL(string: Keys.baseURL + "game_modes"), let requestBody = requestBodyString.data(using: .utf8, allowLossyConversion: false) else { return }
        NetworkController.performRequest(for: requestUrl,
                                          httpMethod: .post,
                                          urlParameters: nil,
                                          body: requestBody) { (data, error) in
            if error != nil {
                print(error,error?.localizedDescription)
                completion([])
                return
            } else {
                guard let recievedData = data else {
                    completion([])
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let gameModes = try decoder.decode([GameMode].self, from: recievedData)
                    completion(gameModes)
                    return
                } catch {
                    print("error parsing data into gameMode object", error, error.localizedDescription)
                    completion([])
                    return
                }
            }
        }
    }
}
