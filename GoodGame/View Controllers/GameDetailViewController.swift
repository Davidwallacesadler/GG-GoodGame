//
//  GameDetailViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import WSTagsField

class GameDetailViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Internal Properties
    
     // TagFields
     fileprivate let gameModeTagsList = WSTagsField()
     fileprivate let platformTagsList = WSTagsField()
     fileprivate let genreTagsList = WSTagsField()
     
     var savedGame: SavedGame?
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
        addTagViews()
        setupTagsViewDelegation()
        setupViewWithSavedGameIfNeeded()
        if let selectedGame = game {
            gameTitleTextField.text = selectedGame.name
        }
     }
    
   override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameModeTagsList.frame = gameModeTagsView.bounds
        platformTagsList.frame = platformTagsView.bounds
        genreTagsList.frame = genreTagsView.bounds
    }

    // MARK: - Outlets
    
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var gameTitleTextField: UITextField!
    @IBOutlet weak var platformTagsView: UIView!
    @IBOutlet weak var genreTagsView: UIView!
    @IBOutlet weak var gameModeTagsView: UIView!
    
    // MARK: - Actions
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        // MARK: - Internal Properties
        
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
    guard let image = gameCover, let title = gameTitleTextField.text else { return }
    SavedGameController.shared.createSavedGame(title: title,
                                               image: image,
                                               platforms: platforms,
                                               genres: genres,
                                               gameModes: gameModes)
    self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Internal Methods
    
    private func addTagViews() {
        WSTagsFieldHelper.addTagsFieldToView(givenView: platformTagsView,
                                             tagField: platformTagsList,
                                             withPlaceholder: "Add a Platform")
        WSTagsFieldHelper.addTagsFieldToView(givenView: genreTagsView,
                                             tagField: genreTagsList,
                                             withPlaceholder: "Add a Genre")
        WSTagsFieldHelper.addTagsFieldToView(givenView: gameModeTagsView,
                                             tagField: gameModeTagsList,
                                             withPlaceholder: "Add a Game Mode")
    }
    
    private func setupTagsViewDelegation() {
        #warning("Cannot edit or select the tagsView for some reason")
        platformTagsList.textDelegate = self
        genreTagsList.textDelegate = self
        gameModeTagsList.textDelegate = self
    }
    
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
       
       private func setupViewWithSavedGameIfNeeded() {
           guard let saveGame = savedGame else { return }
           gameTitleTextField.text = saveGame.title!
           coverArtImageView.image = saveGame.photo
           for platform in saveGame.gamePlatforms!.array {
              let gamePlatform = platform as! GamePlatform
              platformTagsList.addTag(gamePlatform.name!)
           }
           for gameMode in saveGame.playModes!.array {
              let playMode = gameMode as! PlayMode
              gameModeTagsList.addTag(playMode.name!)
           }
           for genre in saveGame.gameGenres!.array {
              let gameGenre = genre as! GameGenre
              genreTagsList.addTag(gameGenre.name!)
           }
      }

}
