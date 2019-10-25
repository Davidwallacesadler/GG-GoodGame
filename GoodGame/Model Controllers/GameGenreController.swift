//
//  GameGenreController.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class GameGenreController {
    
    // MARK: - Shared Instance
    
    static let shared = GameGenreController()
    
    // MARK: - GamePlatorms
    
    var genres: [GameGenre] {
        let request: NSFetchRequest<GameGenre> = GameGenre.fetchRequest()
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
    
    func createGameGenresFor(savedGame: SavedGame, withGenres genres: [String]) {
        for genre in genres {
            let gameGenre = GameGenre(name: genre)
            savedGame.addToGameGenres(gameGenre)
        }
        saveToPersitentStorage()
    }
    
    func updateGameGeneresFor(savedGame: SavedGame, withNewGenres genres: [String]) {
        var newGenres: [GameGenre] = []
        // Remove old:
        for gameGenre in savedGame.gameGenres!.array {
            let genre = gameGenre as! GameGenre
            deleteGameGenre(gameGenre: genre)
        }
        // Add New:
        for genre in genres {
            let newGenre = GameGenre(name: genre)
            newGenres.append(newGenre)
        }
        let newGenresOrderedSet = NSOrderedSet(array: newGenres)
        savedGame.gameGenres = newGenresOrderedSet
        saveToPersitentStorage()
    }
    
    func deleteGameGenre(gameGenre: GameGenre) {
        let moc = gameGenre.managedObjectContext
        moc?.delete(gameGenre)
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
