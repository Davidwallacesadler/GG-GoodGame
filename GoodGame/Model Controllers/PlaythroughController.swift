//
//  PlaythroughController.swift
//  GoodGame
//
//  Created by David Sadler on 10/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

class PlaythroughController {
    
    // MARK: - Shared Instance
    
    static let shared = PlaythroughController()
    
    // MARK: - Fetched Playthroughs
    
    var playthroughs: [PlaythroughHistory] {
        let request: NSFetchRequest<PlaythroughHistory> = PlaythroughHistory.fetchRequest()
        let moc = CoreDataStack.context
        do {
            let result = try moc.fetch(request)
            return result
        } catch {
            return []
        }
    }
    
    // MARK: - CRUD
    
    func createPlaythroughFor(savedGame: SavedGame,
                           userComment: String) {
        guard let playthroughStartDate = savedGame.startOfPlaythrough else { return }
        let newPlaythrough = PlaythroughHistory(startDate: playthroughStartDate, endDate: Date(), userComment: userComment)
        savedGame.addToPlaythroughs(newPlaythrough)
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
