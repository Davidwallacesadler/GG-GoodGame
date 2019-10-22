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
    
    // MARK: - CRUD
    
    func createSavedGame(title: String,
                         image: UIImage,
                         platforms: [String],
                         genres: [String],
                         gameModes: [String]) {
        let imageData: Data?
        imageData = image.jpegData(compressionQuality: 1.0)
        let savedGame = SavedGame(title: title, image: imageData, isFavorite: false, isBeingCurrentlyPlayed: false)
        GamePlatformController.shared.createGamePlatformsFor(savedGame: savedGame, withPlatforms: platforms)
        GameGenreController.shared.createGameGenresFor(savedGame: savedGame, withGenres: genres)
        PlayModeController.shared.createPlayModesFor(savedGame: savedGame, withPlayModes: gameModes)
        saveToPersitentStorage()
    }
    
    func deleteSavedGame(savedGame: SavedGame) {
        let moc = savedGame.managedObjectContext
        moc?.delete(savedGame)
        saveToPersitentStorage()
    }
    
    func invertPlayingStatus(savedGame: SavedGame) {
        savedGame.isBeingCurrentlyPlayed = !savedGame.isBeingCurrentlyPlayed
        saveToPersitentStorage()
    }
    
    func invertFavoriteSatus(savedGame: SavedGame) {
        savedGame.isFavorite = !savedGame.isFavorite
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
