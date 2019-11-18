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
    
    let defaultGenres: Dictionary = [
         "Adventure": 0,
         "Action": 1,
         "Point-and-click": 2,
         "Fighting": 4,
         "Shooter": 5,
         "Music": 7,
         "Platformer": 8,
         "Puzzle": 9,
         "Racing": 10,
         "Real Time Strategy": 11,
         "Role-playing": 12,
         "Simulator": 13,
         "Sport": 14,
         "Strategy": 15,
         "Turn-based Strategy": 16,
         "Horror": 17,
         "Arcade": 18,
         "Casual": 19,
         "Fantasy": 20,
         "Mystery": 21,
         "Science Fiction": 22
     ]

    // MARK: - Filtering
    
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
    
    func loadSavedGamesFromGenreId(genreId: Int) -> [SavedGame] {
        let request: NSFetchRequest<GameGenre> = GameGenre.fetchRequest()
        filteringPredicate = NSPredicate(format: "id == %@", genreId)
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

    func createNewGameGenreNameIdPair(givenTitle: String) -> (String, Int) {
        let genreWithMaxId = genres.max { (genreOne, genreTwo) -> Bool in
            genreOne.id < genreTwo.id
        }
        guard let maxId = genreWithMaxId?.id else { return (givenTitle, 25)}
        if maxId < 25 {
            return (givenTitle, 25)
        } else {
            return (givenTitle, Int(maxId) + 1)
        }
    }
    
    func createGameGenresFor(savedGame: SavedGame, withGenres genreIdPairs: [(String,Int)]) {
        for pair in genreIdPairs {
            let gameGenre = GameGenre(name: pair.0, id: pair.1)
            savedGame.addToGameGenres(gameGenre)
        }
        saveToPersitentStorage()
    }
    
    func updateGameGeneresFor(savedGame: SavedGame, withNewGenres genreIdPairs: [(String,Int)]) {
        var newGenres: [GameGenre] = []
        // Remove old:
        for gameGenre in savedGame.gameGenres!.array {
            let genre = gameGenre as! GameGenre
            deleteGameGenre(gameGenre: genre)
        }
        // Add New:
        for pair in genreIdPairs {
            let newGenre = GameGenre(name: pair.0 ,id: pair.1)
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
