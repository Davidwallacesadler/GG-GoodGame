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
    
    // MARK: - Networking Methods
    
    func searchByGameName(_ gameName: String,
                          completion: @escaping(_ Games: [Game]) -> Void) {
        let requestBodyString = "search " + #""\#(gameName)""# + "; fields name, id, cover, alternative_names, genres, multiplayer_modes, platforms, summary, url;"
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
}
