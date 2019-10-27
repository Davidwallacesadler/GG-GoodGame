//
//  PlaythroughHistory+convenience.swift
//  GoodGame
//
//  Created by David Sadler on 10/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

extension PlaythroughHistory {
    convenience init(startDate: Date,
                     endDate: Date,
                     userComment: String,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context:context)
        self.startDate = startDate
        self.endDate = endDate
        self.userComment = userComment
    }
}
