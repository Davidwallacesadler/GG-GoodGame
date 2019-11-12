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
    
    let possiblePlayModes: Dictionary = [
        "Single player": 1,
        "Multiplayer": 2,
        "Co-operative": 3,
        "Split screen": 4,
        "Massively Multiplayer Online (MMO)": 5
    ]
    
    
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
    
    func fetchSavedGameFromPlayModePredicateString(predicateString: String) -> [SavedGame] {
        let request: NSFetchRequest<PlayMode> = PlayMode.fetchRequest()
        filteringPredicate = NSPredicate(format: predicateString)
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
    
    func createPlayModesFor(savedGame: SavedGame, withPlayModes modeIdPairs: [(String,Int)]) {
        for pair in modeIdPairs {
            let playMode = PlayMode(name: pair.0, id: pair.1)
            savedGame.addToPlayModes(playMode)
        }
        saveToPersitentStorage()
    }
    
//    func createCustomPlatformNameIdPair(givenTitle: String) -> (String, Int) {
//           let platformMaxId = platforms.max { (platformOne, platformTwo) -> Bool in
//               platformOne.id < platformTwo.id
//           }
//           guard let maxId = platformMaxId?.id else { return (givenTitle, 200)}
//           if maxId < 200 {
//               return (givenTitle, 200)
//           } else {
//               return (givenTitle, Int(maxId) + 1)
//           }
//       }
    
    func createCustomPlayModeNameIdPair(givenTitle: String) -> (String, Int) {
        let playModeMaxId = playModes.max { (playModeOne, playModeTwo) -> Bool in
            return playModeOne.id < playModeTwo.id
        }
        guard let maxId = playModeMaxId?.id else { return (givenTitle, 10) }
        if maxId < 10 {
            return (givenTitle, 10)
        } else {
             return (givenTitle, Int(maxId) + 1)
        }
        
    }
    
    func updatePlayModesFor(savedGame: SavedGame, withNewPlayModes modeIdPairs: [(String,Int)]) {
        var newPlayModes: [PlayMode] = []
        for playMode in savedGame.playModes!.array {
            let mode = playMode as! PlayMode
            deletePlayMode(playMode: mode)
        }
        for pair in modeIdPairs {
            let newPlayMode = PlayMode(name: pair.0, id: pair.1)
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

