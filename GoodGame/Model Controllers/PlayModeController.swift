//
//  PlayModeController.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class PlayModeController {
    
    // MARK: - Shared Instance
    
    static let shared = PlayModeController()
    var filteringPredicate: NSPredicate?
    
    // MARK: - GamePlatorms
    
    var playModes: [PlayMode] {
        let request: NSFetchRequest<PlayMode> = PlayMode.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    func loadSavedGamesBasedOnPlayModeNames(playModeName: String) -> [SavedGame] {
        let request: NSFetchRequest<PlayMode> = PlayMode.fetchRequest()
        filteringPredicate = NSPredicate(format: "name == %@", playModeName)
        request.predicate = filteringPredicate
        let moc = CoreDataStack.context
        var playModes = [PlayMode]()
        do {
            let result = try moc.fetch(request)
            playModes = result
        } catch {
            print(error,error.localizedDescription)
            return []
        }
        return playModes.map { (playMode) -> SavedGame in
            return playMode.savedGame!
        }
    }
    
    // MARK: - CRUD
    
    // Use an Dictionary to get an ID for the platform - maybe just save the id from the api?
    // This dictionary matches up with the platfrom ids from IGDB
    //let possiblePlatforms: Dictionary = ["Linux":3,"Nintendo 64":4,]
    
    func createPlayModesFor(savedGame: SavedGame, withPlayModes modes: [String]) {
        for mode in modes {
            let playMode = PlayMode(name: mode)
            savedGame.addToPlayModes(playMode)
        }
        saveToPersitentStorage()
    }
    
    func updatePlayModesFor(savedGame: SavedGame, withNewPlayModes modes: [String]) {
        var newPlayModes: [PlayMode] = []
        for playMode in savedGame.playModes!.array {
            let mode = playMode as! PlayMode
            deletePlayMode(playMode: mode)
        }
        for mode in modes {
            let newPlayMode = PlayMode(name: mode)
            newPlayModes.append(newPlayMode)
        }
        let newPlayModesOrderedSet = NSOrderedSet(array: newPlayModes)
        savedGame.playModes = newPlayModesOrderedSet
        saveToPersitentStorage()
    }
    
    func deletePlayMode(playMode: PlayMode) {
        let moc = playMode.managedObjectContext
        moc?.delete(playMode)
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

