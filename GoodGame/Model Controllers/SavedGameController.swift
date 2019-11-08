//
//  SavedGameController.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class SavedGameController {
    
    // MARK: - Shared Instance
    
    static let shared = SavedGameController()
    
    // MARK: - SavedGames Collection
    
    #warning("need some kind of loadSavedData() method that will take in the desired predicate")
    var filteringPredicate: NSPredicate?
    
    var savedGames: [SavedGame] {
        let request: NSFetchRequest<SavedGame> = SavedGame.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    #warning("could use predicate here with savedGames to get attributes of the saved game -- IE should use predicates here for isFavorite, hasBeenCompleted ---- CAN NOT USE A 'TO-MANY' RELATIONSHIP")
    func loadFavoriteGames() -> [SavedGame] {
        let request: NSFetchRequest<SavedGame> = SavedGame.fetchRequest()
        filteringPredicate = NSPredicate(format: "(isFavorite == YES)")
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
    }
    
    func loadCurrentlyPlayingGames() -> [SavedGame] {
        let request: NSFetchRequest<SavedGame> = SavedGame.fetchRequest()
        filteringPredicate = NSPredicate(format: "(isBeingCurrentlyPlayed == YES)")
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
    }
    

    
    // MARK: - CRUD
    
    #warning("FIX INCONSISTENT NAMING OF PLAYMODE AND GAME MODE")
    func createSavedGame(title: String,
                         image: UIImage,
                         platforms: [String],
                         genres: [String],
                         gameModes: [String]) {
        let imageData: Data?
        imageData = image.jpegData(compressionQuality: 1.0)
        let savedGame = SavedGame(title: title, image: imageData, isFavorite: false, isBeingCurrentlyPlayed: false, startOfPlaythrough: nil)
        GamePlatformController.shared.createGamePlatformsFor(savedGame: savedGame, withPlatforms: platforms)
        GameGenreController.shared.createGameGenresFor(savedGame: savedGame, withGenres: genres)
        PlayModeController.shared.createPlayModesFor(savedGame: savedGame, withPlayModes: gameModes)
        saveToPersitentStorage()
    }
    
    func updateSavedGame(newTitle title: String,
                         newImage image: UIImage,
                         newPlatforms platforms: [String],
                         newGenres genres: [String],
                         newPlayModes playModes: [String],
                         gameToUpdate savedGame: SavedGame) {
        let imageData: Data?
        imageData = image.jpegData(compressionQuality: 1.0)
        savedGame.title = title
        savedGame.image = imageData
        GamePlatformController.shared.updateGamePlatformsFor(savedGame: savedGame, withPlatforms: platforms)
        GameGenreController.shared.updateGameGeneresFor(savedGame: savedGame, withNewGenres: genres)
        PlayModeController.shared.updatePlayModesFor(savedGame: savedGame, withNewPlayModes: playModes)
        saveToPersitentStorage()
    }
    
    func deleteSavedGame(savedGame: SavedGame) {
        let moc = savedGame.managedObjectContext
        moc?.delete(savedGame)
        saveToPersitentStorage()
    }
    
    
    // MARK: - Helper Methods
    
    func invertPlayingStatus(savedGame: SavedGame) {
        savedGame.isBeingCurrentlyPlayed = !savedGame.isBeingCurrentlyPlayed
        saveToPersitentStorage()
    }
    
    func invertFavoriteSatus(savedGame: SavedGame) {
        savedGame.isFavorite = !savedGame.isFavorite
        saveToPersitentStorage()
    }
    
    func createPlaythroughHistory(savedGame: SavedGame, withComment: String) {
        PlaythroughController.shared.createPlaythroughFor(savedGame: savedGame, userComment: withComment)
        saveToPersitentStorage()
    }
    
    func setBeginningOfPlaythroughDate(forSavedGame savedGame: SavedGame) {
        savedGame.startOfPlaythrough = Date()
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
