//
//  Platform+convenience.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import CoreData

extension GamePlatform {
    convenience init(name: String,
                     id: Int,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.id = Int16(id)
        self.name = name
    }
}
