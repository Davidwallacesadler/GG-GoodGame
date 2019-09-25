//
//  GameController.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

struct GameController {
    // MARK: - Shared Instance
    
    static let shared = GameController()
    
    // MARK: - Networking Methods
    
    func searchByGameName(_ gameName: String,
                          completion: @escaping(_ Games: [Game]?) -> Void) {
        guard let requestURL = URL(string: Keys.baseURL + "games") else { return }
        let requestBodyString = #"search "\(gameName)"; fields name;"#
        NetworkController.performRequest(for: requestURL,
                                         httpMethod: .post,
                                         urlParameters: nil,
                                         body: requestBodyString.data(using: .utf8)) { (data, error) in
            if error != nil {
                print(error?.localizedDescription, error)
                completion(nil)
            } else {
                guard let recievedData = data else {
                    completion(nil)
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    let games = try jsonDecoder.decode([Game].self, from: recievedData)
                    completion(games)
                    return
                } catch {
                    print(error.localizedDescription, error)
                }
            }
                            
        }
    }
    
    
    
}
