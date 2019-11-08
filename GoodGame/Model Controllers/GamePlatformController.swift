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
    var filteringPredicate: NSPredicate?
    
    // MARK: - CRUD
    
    // Use an Dictionary to get an ID for the platform - maybe just save the id from the api?
    // This dictionary matches up with the platfrom ids from IGDB
    //let possiblePlatforms: Dictionary = ["Linux":3,"Nintendo 64":4,]
    
    func fetchSavedGameFromPlatformPredicateString(predicateString: String) -> [SavedGame] {
        let request: NSFetchRequest<GamePlatform> = GamePlatform.fetchRequest()
        filteringPredicate = NSPredicate(format: predicateString)
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        var gamePlatforms = [GamePlatform]()
        do {
            let result = try moc.fetch(request)
            gamePlatforms = result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
        return gamePlatforms.map { (gamePlatform) -> SavedGame in
            return gamePlatform.savedGame!
        }
    }
    
    func loadSavedGamesFromPlatform(platformName: String) -> [SavedGame] {
        let request: NSFetchRequest<GamePlatform> = GamePlatform.fetchRequest()
        filteringPredicate = NSPredicate(format: "name == %@", platformName)
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        var gamePlatforms = [GamePlatform]()
        do {
            let result = try moc.fetch(request)
            gamePlatforms = result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
        return gamePlatforms.map { (gamePlatform) -> SavedGame in
            return gamePlatform.savedGame!
        }
    }
    
    func createGamePlatformsFor(savedGame: SavedGame, withPlatforms platforms: [String]) {
        for platform in platforms {
            let gamePlatform = GamePlatform(name: platform)
            savedGame.addToGamePlatforms(gamePlatform)
        }
        saveToPersitentStorage()
    }
    
    // NEED TO REMOVE OLD PLATFROM OBJECTS
    func updateGamePlatformsFor(savedGame: SavedGame, withPlatforms platforms: [String]) {
        var newPlatforms: [GamePlatform] = []
        // Delete Old Platforms:
        for gamePlatform in savedGame.gamePlatforms!.array {
            let platform = gamePlatform as! GamePlatform
            deleteGamePlatforms(givenPlatform: platform)
        }
        // Add New Platforms:
        for platform in platforms {
            let newGamePlatform = GamePlatform(name: platform)
            newPlatforms.append(newGamePlatform)
        }
        let newPlatformsOrderedSet = NSOrderedSet(array: newPlatforms)
        savedGame.gamePlatforms = newPlatformsOrderedSet
        saveToPersitentStorage()
    }
    
    func deleteGamePlatforms(givenPlatform: GamePlatform) {
        let moc = givenPlatform.managedObjectContext
        moc?.delete(givenPlatform)
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

