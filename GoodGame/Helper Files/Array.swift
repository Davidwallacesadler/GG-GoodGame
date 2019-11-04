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

protocol Gamed {
    var game: SavedGame { get }
}

protocol Named {
    var name: String { get }
}

extension Array where Element: Gamed {
    func groupedByFirstTitleLetter() -> [String: [Element]] {
        let initialAccumulatingValue: [String: [Element]] = [:]
        let groupedByFirstLetter = reduce(into: initialAccumulatingValue) {accumulatingValue, modifyingValue in
            let title = modifyingValue.game.title!
            let firstLetter = "\(title.first!)"
            let existing = accumulatingValue[firstLetter] ?? []
            accumulatingValue[firstLetter] = existing + [modifyingValue]
        }
        print(groupedByFirstLetter.description)
        return groupedByFirstLetter
    }
}

extension Array where Element: Named {
    func groupedByFirstTitleLetterString() -> [String: [Element]] {
        let initialAccumulatingValue: [String: [Element]] = [:]
        let groupedByFirstLetter = reduce(into: initialAccumulatingValue) {accumulatingValue, modifyingValue in
            let title = modifyingValue.name
            let firstLetter = "\(title.first!)"
            let existing = accumulatingValue[firstLetter] ?? []
            accumulatingValue[firstLetter] = existing + [modifyingValue]
        }
        print(groupedByFirstLetter.description)
        return groupedByFirstLetter
    }
}
