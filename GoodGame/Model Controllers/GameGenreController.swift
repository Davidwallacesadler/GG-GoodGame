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
    var filteringPredicate: NSPredicate?
    
    // MARK: - Game Genres
    
    let possibleGenres: Dictionary = [
        "Point-and-click": 2,
        "Fighting": 4,
        "Shooter": 5,
        "Music": 7,
        "Platform": 8,
        "Puzzle": 9,
        "Racing": 10,
        "Real Time Strategy (RTS)": 11,
        "Role-playing (RPG)": 12,
        "Simulator": 13,
        "Sport": 14,
        "Strategy": 15,
        "Turn-based strategy (TBS)": 16
    ]
    
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
    
    func fetchSavedGameFromGenrePredicateString(predicateString: String) -> [SavedGame] {
        let request: NSFetchRequest<GameGenre> = GameGenre.fetchRequest()
        filteringPredicate = NSPredicate(format: predicateString)
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        var gameGenres = [GameGenre]()
        do {
            let result = try moc.fetch(request)
            gameGenres = result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
        return gameGenres.map { (gameGenre) -> SavedGame in
            return gameGenre.savedGame!
        }
    }
    
    func loadSavedGamesBasedOnGenreName(genreName: String) -> [SavedGame] {
        let request: NSFetchRequest<GameGenre> = GameGenre.fetchRequest()
        filteringPredicate = NSPredicate(format: "name == %@", genreName)
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        var genres = [GameGenre]()
        do {
            let result = try moc.fetch(request)
            genres = result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
        return genres.map { (gameGenre) -> SavedGame in
            return gameGenre.savedGame!
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
