//
//  GameDetailViewController.swift
//  GoodGame
//
//  Created by David Sadler on 9/26/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    
    // MARK: - View Lifeycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedGame = game {
            gameTitleLabel.text = selectedGame.name
        }
    }
    
    // MARK: - Internal Properites
        // GAME MODES:
        var gameModeString = ""
        var gameModeIds: [Int]?
        var gameModes: [GameMode]? {
            didSet {
                DispatchQueue.main.async {
                    self.updateGameModesLabel()
                }
            }
        }
        // GENRES:
        var genresString = ""
        var genreIds: [Int]?
        var genres: [Genre]? {
            didSet {
                DispatchQueue.main.async {
                    self.updateGenresLabel()
                }
            }
        }
        // PLATFORMS:
        var gamePlatforms: [Platform]? {
            didSet {
                DispatchQueue.main.async {
                    self.updatePlatformsLabel()
                }
            }
        }
        var platformsString = ""
        var gamePlaftormIds: [Int]?
        // GAME COVER:
        var gameId: Int?
        var gameCover: UIImage? {
        didSet {
                DispatchQueue.main.async {
                    self.updateImageView()
                }
            }
        }
       var game: Game? {
           didSet {
            GameController.shared.getCoverImageByGameId(gameId!) { (image) in
                guard let coverImage = image else { return }
                self.gameCover = coverImage
               }
            if let platformIds = gamePlaftormIds {
                for id in platformIds {
                    GameController.shared.getPlatformByPlatformId(id) { (gamePlatforms) in
                        self.gamePlatforms = gamePlatforms
                    }
                }
            }
            if let genres = genreIds {
                for id in genres {
                    GameController.shared.getGenreByGenreId(id) { (genres) in
                        self.genres = genres
                    }
                }
            }
            if let modeIds = gameModeIds {
                for id in modeIds {
                    GameController.shared.getGameModesByModeId(id) { (gameModes) in
                        self.gameModes = gameModes
                    }
                }
            }
        }
   }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gamePlatformsLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var gameModesLabel: UILabel!
    
    // MARK: - Internal Methods
    
    private func updateImageView() {
        if let gameImage = gameCover {
            self.gameCoverImageView.image = gameImage
        }
    }
    
    private func updatePlatformsLabel() {
        if let platforms = gamePlatforms {
            for platform in platforms {
                if platformsString.isEmpty {
                    platformsString += platform.name
                } else {
                    platformsString += ", \(platform.name)"
                }
            }
            gamePlatformsLabel.text = platformsString
        }
    }
    
    private func updateGenresLabel() {
        if let genres = genres {
            for genre in genres {
                if genresString.isEmpty {
                    genresString += genre.name
                } else {
                    genresString += ", \(genre.name)"
                }
            }
            genresLabel.text = genresString
        }
    }
    
    private func updateGameModesLabel() {
        if let gameModes = gameModes {
            for mode in gameModes {
                if gameModeString.isEmpty {
                    gameModeString += mode.name
                } else {
                    gameModeString += ", \(mode.name)"
                }
            }
            gameModesLabel.text = gameModeString
        }
    }

}
