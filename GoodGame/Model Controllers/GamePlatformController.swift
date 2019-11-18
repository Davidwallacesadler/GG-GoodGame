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
    
    let defaultPlatforms: Dictionary = [
        "Linux":3,
        "Nintendo 64":4,
        "Wii": 5,
        "PC": 6,
        "PlayStation": 7,
        "PlayStation 2": 8,
        "PlayStation 3": 9,
        "Xbox": 11,
        "Xbox 360": 12,
        "PC DOS": 13,
        "Mac": 14,
        "Commodore C64/128": 15,
        "Amiga": 16,
        "NES": 18,
        "SNES": 19,
        "Nintendo DS": 20,
        "Nintendo GameCube": 21,
        "Game Boy Color": 22,
        "Dreamcast": 23,
        "Game Boy Advance": 24,
        "Amstrad CPC": 25,
        "ZX Spectrum": 26,
        "MSX": 27,
        "Sega Genesis": 29,
        "Sega 32X": 30,
        "Sega Saturn": 32,
        "Game Boy": 33,
        "Android": 34,
        "Sega Game Gear": 35,
        "Xbox Live Arcade": 36,
        "Nintendo 3DS": 37,
        "PlayStation Portable": 38,
        "iOS": 39,
        "Wii U": 41,
        "N-Gage": 42,
        "Tapwave Zodiac": 44,
        "PlayStation Network": 45,
        "PlayStation Vita": 46,
        "Virtual Console": 47,
        "PlayStation 4": 48,
        "Xbox One": 49,
        "3DO Interactive Multiplayer": 50,
        "Family Computer Disc System": 51,
        "Arcade": 52,
        "MSX2": 52,
        "Mobile": 55,
        "WiiWare": 56,
        "WonderSwan": 57,
        "Super Famicom": 58,
        "Atari 2600": 59,
        "Atari 7800": 60,
        "Atari Lynx": 61,
        "Atari Jaguar": 62,
        "Atari ST/STE": 63,
        "Sega Master System": 64,
        "Atari 8-bit": 65,
        "Atari 5200": 66,
        "Intellivision": 67,
        "ColecoVision": 68,
        "Vectrex": 70,
        "Commodore VIC-20": 71,
        "Apple II": 75,
        "Sharp X1": 77,
        "Sega CD": 78,
        "Neo Geo MVS": 79,
        "Neo Geo AES": 80,
        "Web browser": 82,
        "TurboGrafx-16": 86,
        "Virtual Boy": 87,
        "Odyssey": 88,
        "Microvision": 89,
        "Commodore PET": 90,
        "Bally Astrocade": 91,
        "Commodore 16": 93,
        "Commodore Plus/4": 94,
        "FAMICOM": 99,
        "Amiga CD 32": 114,
        "Apple IIGS": 115,
        "Neo Geo Pocket": 119,
        "Neo Geo Pocket Color": 120,
        "WonderSwan Color": 123,
        "SwanCrystal": 124,
        "PC Engine SuperGrafx": 128,
        "Nintendo Switch": 130,
        "New Nintendo 3DS": 137,
        "Nintendo DSi": 159,
        "Nintendo eShop": 160,
        "Oculus VR": 162,
        "SteamVR": 163,
        "PlayStation VR": 165
    ]
    
    // MARK: - Filtering
    
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
    
    func loadSavedGamesFromPlatformId(platformId: Int) -> [SavedGame] {
        let request: NSFetchRequest<GamePlatform> = GamePlatform.fetchRequest()
        filteringPredicate = NSPredicate(format: "name == %@", platformId)
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
    
    // MARK: - CRUD
    
    func createGamePlatformsFor(savedGame: SavedGame, withPlatforms platformIdPairs: [(String, Int)]) {
        for pair in platformIdPairs {
            let gamePlatform = GamePlatform(name: pair.0, id: pair.1)
            savedGame.addToGamePlatforms(gamePlatform)
        }
        saveToPersitentStorage()
    }
    
    func createCustomPlatformNameIdPair(givenTitle: String) -> (String, Int) {
        let platformMaxId = platforms.max { (platformOne, platformTwo) -> Bool in
            platformOne.id < platformTwo.id
        }
        guard let maxId = platformMaxId?.id else { return (givenTitle, 200)}
        if maxId < 200 {
            return (givenTitle, 200)
        } else {
            return (givenTitle, Int(maxId) + 1)
        }
    }
    
    // NEED TO REMOVE OLD PLATFROM OBJECTS
    func updateGamePlatformsFor(savedGame: SavedGame, withPlatforms platformIdPairs: [(String, Int)]) {
        var newPlatforms: [GamePlatform] = []
        // Delete Old Platforms:
        for gamePlatform in savedGame.gamePlatforms!.array {
            let platform = gamePlatform as! GamePlatform
            deleteGamePlatforms(givenPlatform: platform)
        }
        // Add New Platforms:
        for pair in platformIdPairs {
            let newGamePlatform = GamePlatform(name: pair.0, id: pair.1)
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

