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
    @IBOutlet weak var playthroughHistoryBarButtonItem: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction func playthroughHistoryButtonPressed(_ sender: Any) {
        guard let game = savedGame else { return }
        if game.playthroughs?.array.isEmpty == false {
            self.performSegue(withIdentifier: "toShowHistory", sender: self)
        }
    }
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        #warning("get a default image for the game")
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
        guard let title = gameTitleTextField.text else { return }
        guard let currentlySavedGame = savedGame else {
            SavedGameController.shared.createSavedGame(title: title,
                                                       image: coverArtImageView.image ?? UIImage(named: "defaultCoverImage")!,
                                                              platforms: platforms,
                                                              genres: genres,
                                                              gameModes: gameModes)
            self.navigationController?.popViewController(animated: true)
            return
        }
        SavedGameController.shared.updateSavedGame(newTitle: title,
                                                   newImage: coverArtImageView.image ?? UIImage(named: "defaultCoverImage")!,
                                                   newPlatforms: platforms,
                                                   newGenres: genres,
                                                   newPlayModes: gameModes,
                                                   gameToUpdate: currentlySavedGame)
        self.navigationController?.popViewController(animated: true)
        }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        getImage()
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
        if saveGame.playthroughs?.array.isEmpty == false {
            playthroughHistoryBarButtonItem.tintColor = .goodGamePinkBright
        }
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

extension GameDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func getImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("Camera not available")
                let cameraNotAvailableAlertController = UIAlertController(title: "Camera not available", message: "You have not given permission to use the camera or there is not an available camera to use", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                cameraNotAvailableAlertController.addAction(okAction)
                self.present(cameraNotAvailableAlertController, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
        }))
        if let popoverController = actionSheet.popoverPresentationController {
            let cancelButton = UIAlertAction(title: "Cancel", style: .default) { (_) in
                actionSheet.dismiss(animated: true, completion: nil)
            }
            actionSheet.addAction(cancelButton)
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
               return
           }
        coverArtImageView.image = originalImage
        coverArtImageView.contentMode = .scaleAspectFill
        picker.dismiss(animated: true, completion: nil)
    }
}

extension GameDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowHistory" {
            guard let historyVC = segue.destination as? PlaythroughHistoryListTableViewController, let selectedGame = savedGame else { return }
            historyVC.savedGame = selectedGame
        }
    }
}
