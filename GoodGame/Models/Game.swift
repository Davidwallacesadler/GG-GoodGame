//
//  Game.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

// Made up of all the id's of associated types:
struct Game: Codable {
    let id: Int
    let alternative_names: [Int]?
    let cover: Int?
    let genres: [Int]?
    let game_modes: [Int]?
    let name: String
    let platforms: [Int]?
    let summary: String?
    let url: String
}

struct MultiplayerModes: Codable {
    let id: Int
    let campaigncoop: Bool
    let offlinecoop: Bool
    let onlinecoop: Bool
    let splitscreen: Bool
}

struct GameMode: Codable {
    let id: Int
    let name: String
}

struct Platform: Codable {
    let id: Int
    let abbreviation: String
    let alternative_name: String?
    let category: Int
    let generation: Int?
    let name: String
    let platform_logo: Int?
    let url: String
}

struct Genre: Codable {
    let id: Int
    let name: String
}

struct AlternativeName: Codable {
    let comment: String
    let game: Int
    let name: String
}

struct Artwork: Codable {
    let id: Int
    let url: String?
}

enum Catagory: Int {
    case console = 1
    case arcade = 2
    case plaform = 3
    case operatingSystem = 4
    case portableComputer = 5
    case computer = 6
}
