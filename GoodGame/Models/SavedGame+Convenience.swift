//
//  SavedGame+Convenience.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension SavedGame {
    var photo: UIImage {
        guard let image = image else { return UIImage() }
        guard let photo = UIImage(data: image as Data) else { return UIImage() }
        return photo
    }
    convenience init(title: String,
                     image: Data?,
                     context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.title = title
        self.image = image
    }
}
