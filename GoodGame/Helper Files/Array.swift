//
//  Array.swift
//  GoodGame
//
//  Created by David Sadler on 10/21/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
