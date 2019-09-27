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
    let multiplayer_modes: [Int]?
    let name: String
    let platforms: [Int]?
    let summary: String?
    let url: String
}

struct MultiplayerModes: Codable {
    let campaigncoop: Bool
    let dropin: Bool
    let game: Int
    let lancoop: Bool
    let offlinecoop: Bool
    let offlinecoopmax: Int
    let offlinemax: Int
    let onlinecoop: Bool
    let onlinecoopmax: Int
    let onlinemax: Int
    let platform: Platform
    let splitscreen: Bool
    let splitscreenonline: Bool
}

struct Platform: Codable {
    let abbreviation: String
    let alternative_name: String
    let generation: Int
    let name: String
    let platform_logo: Artwork
    let url: String
}

struct Genre: Codable {
    let name: String
    let slug: String
    let url: String
}

struct AlternativeName: Codable {
    let comment: String
    let game: Int
    let name: String
}

struct Artwork: Codable {
    let id: Int?
    let url: String?
}
