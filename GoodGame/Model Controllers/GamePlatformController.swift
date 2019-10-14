//
//  GamePlatformController.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class GamePlatformController {
    
    // MARK: - Shared Instance
    
    static let shared = GamePlatformController()
    
    // MARK: - GamePlatorms
    
    var platforms: [GamePlatform] {
        let request: NSFetchRequest<GamePlatform> = GamePlatform.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - CRUD
    
    // Use an Dictionary to get an ID for the platform - maybe just save the id from the api?
    // This dictionary matches up with the platfrom ids from IGDB
    //let possiblePlatforms: Dictionary = ["Linux":3,"Nintendo 64":4,]
    
    func createGamePlatformsFor(savedGame: SavedGame, withPlatforms platforms: [String]) {
        for platform in platforms {
            let gamePlatform = GamePlatform(name: platform)
            savedGame.addToGamePlatforms(gamePlatform)
        }
        saveToPersitentStorage()
    }
    
    // MARK: - Persistence
    
    func saveToPersitentStorage() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print(error,error.localizedDescription)
        }
    }
}

