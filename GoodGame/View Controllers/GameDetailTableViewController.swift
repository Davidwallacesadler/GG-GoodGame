//
//  GameDetailTableViewController.swift
//  GoodGame
//
//  Created by David Sadler on 9/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import WSTagsField

class GameDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Internal Properties
    // TagFields
    fileprivate let gameModeTagsList = WSTagsField()
    fileprivate let platformTagsList = WSTagsField()
    fileprivate let genreTagsList = WSTagsField()
    
    var gameModeName = ""
    var gameModeIds: [Int]?
    var gameModes: [GameMode]? {
        didSet {
            DispatchQueue.main.async {
                self.updateGameModeTagsView()
            }
        }
    }
    // GENRES:
    var genreName = ""
    var genreIds: [Int]?
    var genres: [Genre]? {
        didSet {
            DispatchQueue.main.async {
                self.updateGenreTagsView()
            }
        }
    }
    // PLATFORMS:
    var platformName = ""
    var gamePlatforms: [Platform]? {
        didSet {
            DispatchQueue.main.async {
                self.updatePlatformTagsView()
            }
        }
    }
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
   // GAME:
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
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        WSTagsFieldHelper.addTagsFieldToView(givenView: platformTagsView,
                                             tagField: platformTagsList,
                                             withPlaceholder: "Add a Platform")
        WSTagsFieldHelper.addTagsFieldToView(givenView: genreTagsView,
                                             tagField: genreTagsList,
                                             withPlaceholder: "Add a Genre")
        WSTagsFieldHelper.addTagsFieldToView(givenView: gameModesTagsView,
                                             tagField: gameModeTagsList,
                                             withPlaceholder: "Add a Game Mode")
        platformTagsList.delegate = self
        genreTagsList.delegate = self
        gameModeTagsList.delegate = self
        if let selectedGame = game {
            gameTitleLabel.text = selectedGame.name
        }
    }

   // MARK: - Outlets
    
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var platformTagsView: UIView!
    @IBOutlet weak var genreTagsView: UIView!
    @IBOutlet weak var gameModesTagsView: UIView!
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var genres = [String]()
        var platforms = [String]()
        var gameModes = [String]()
        for genre in genreTagsList.tags {
            genres.append(genre.text)
        }
        for platform in platformTagsList.tags {
            platforms.append(platform.text)
        }
        for gameMode in gameModeTagsList.tags {
            gameModes.append(gameMode.text)
        }
        #warning("get a default image for the game")
        guard let image = gameCover, let title = gameTitleLabel.text else { return }
        let newSavedGame = SavedGame(title: title, image: image.jpegData(compressionQuality: 1.0))
        GamePlatformController.shared.createGamePlatformsFor(savedGame: newSavedGame,
                                                             withPlatforms: platforms)
        GameGenreController.shared.createGameGenresFor(savedGame: newSavedGame,
                                                       withGenres: genres)
        PlayModeController.shared.createPlayModesFor(savedGame: newSavedGame,
                                                     withPlayModes: gameModes)
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Internal Methods
    
    private func updateImageView() {
        if let gameImage = gameCover {
            self.coverArtImageView.image = gameImage
            gameCover = gameImage
        }
    }
    
    private func updatePlatformTagsView() {
        if let platforms = gamePlatforms {
            for platform in platforms {
                platformTagsList.addTag(platform.name)
            }
        }
    }
    
    private func updateGenreTagsView() {
        if let genres = genres {
            for genre in genres {
                genreTagsList.addTag(genre.name)
            }
        }
    }
    
    private func updateGameModeTagsView() {
        if let gameModes = gameModes {
            for mode in gameModes {
                gameModeTagsList.addTag(mode.name)
            }
        }
    }
    
    
}
