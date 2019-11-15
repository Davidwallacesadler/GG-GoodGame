//
//  GameDetailViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/17/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import WSTagsField

class GameDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - TableView Delegate / Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tagSuggestions[indexPath.row]
        if currentlySelectedTagsView == gameModeTagsView {
            if suggestionTableViewHasBeenFlipped {
                cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            }
        } else {
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedTagsList = currentlySelectedTagsList else { return }
        // ADD TO GENRES -- WHICH ADDS TO TAGS
        #warning("goal is to make a tuple here and create a Genre Object")
        suggestedTagTableView.removeFromSuperview()
        let selectedTagToAdd = tagSuggestions[indexPath.row]
        selectedTagsList.addTag(selectedTagToAdd)
 
    }
    
    // MARK: - Internal Properties
    
     // TagFields
    fileprivate let gameModeTagsList = WSTagsField()
    fileprivate let platformTagsList = WSTagsField()
    fileprivate let genreTagsList = WSTagsField()
    var currentlySelectedTagsView: UIView?
    var currentlySelectedTagsList: WSTagsField?
    var suggestionTableViewHasBeenFlipped: Bool = false
    var possiblePlatforms = GamePlatformController.shared.possiblePlatforms.map { (keyValue) -> String in
        return keyValue.key
    }
    var possibleGenres = GameGenreController.shared.possibleGenres.map { (keyValue) -> String in
        return keyValue.key
    }
    var possiblePlayModes = PlayModeController.shared.possiblePlayModes.map { (keyValue) -> String in
        return keyValue.key
    }
    var tagSuggestions: [String] = [] {
        didSet {
            DispatchQueue.main.async {
            guard let selectedTagView = self.currentlySelectedTagsView else { return }
                if selectedTagView == self.gameModeTagsView {
                    self.suggestionTableViewHasBeenFlipped = true
                    self.suggestedTagTableView.frame = CGRect(x: selectedTagView.frame.origin.x, y: selectedTagView.frame.origin.y - (self.view.frame.height * 0.15), width: selectedTagView.frame.width, height: (self.view.frame.height * 0.15))
                } else {
                    self.suggestionTableViewHasBeenFlipped = false
                    self.suggestedTagTableView.frame = CGRect(x: selectedTagView.frame.origin.x, y: selectedTagView.frame.origin.y + selectedTagView.frame.height, width: selectedTagView.frame.width, height: (self.view.frame.height * 0.15))
                }
                if self.suggestionTableViewHasBeenFlipped {
                    self.suggestedTagTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
                    self.suggestionTableViewHasBeenFlipped = true
                } else {
                    self.suggestedTagTableView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                self.view.addSubview(self.suggestedTagTableView)
                self.suggestedTagTableView.reloadData()
            }
        }
    }
    
    var imageHasChanged: Bool = false
     var savedGame: SavedGame?
     var gameModeIds: [Int]?
     var gameModes: [GameMode]? {
         didSet {
             DispatchQueue.main.async {
                 self.updateGameModeTagsView()
             }
         }
     }
     // GENRES:
    var genreIds: [Int]?
    var genres: [Genre]? {
         didSet {
             DispatchQueue.main.async {
                 self.updateGenreTagsView()
             }
         }
     }
     // PLATFORMS:
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
    var artworks: [Artwork]?
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
        if let artworkArray = artworks {
            GameController.shared.getCoverImageByArtworks(artworkArray) { (image) in
                guard let coverImage = image else { return }
                self.gameCover = coverImage
                self.imageHasChanged = true
            }
        }
        #warning("replace the rest of these network calls with keys from my dictionaries -- fixes naming and other issues.")
        if let platformIds = gamePlaftormIds {
            GameController.shared.getPlatformsByPlatformIds(platformIds) { (gamePlatforms) in
                self.gamePlatforms = gamePlatforms
            }
        }
        if let genres = genreIds {
            GameController.shared.getGenresByGenreIds(genres) { (genres) in
                self.genres = genres
            }
        }
        if let modeIds = gameModeIds {
            GameController.shared.getGameModesByModeIds(modeIds) { (gameModes) in
                self.gameModes = gameModes
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
        accountForCustomTags()
        //resignFirstResponderTapRecongnizerSetup()
        if let selectedGame = game {
            gameTitleTextField.text = selectedGame.name
        }
        setupColorsBasedOnDarkMode()
        
        suggestedTagTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        suggestedTagTableView.delegate = self
        suggestedTagTableView.dataSource = self
        
        #warning("Instead of adding text")
        platformTagsList.onDidSelectTagView = { tagList, tagView in
            print("setting currently selected tags")
            self.currentlySelectedTagsList = tagList
            self.currentlySelectedTagsView = tagView
        }
        platformTagsList.onDidChangeText = {tagsList, text in
            self.currentlySelectedTagsView = self.platformTagsView
            self.currentlySelectedTagsList = tagsList
            if text!.isEmpty {
                self.suggestedTagTableView.removeFromSuperview()
            } else {
                let platforms: [String] = self.possiblePlatforms.compactMap { (platform) -> String? in
                    if platform.lowercased().contains(text!.lowercased()) {
                        return platform
                    } else {
                        return nil
                    }
                }
                if platforms.isEmpty == false {
                    self.tagSuggestions = platforms
                }
            }
            print("Platform Text Changed")
        }
        
        genreTagsList.onDidChangeText = {tagsList, text in
            self.currentlySelectedTagsView = self.genreTagsView
            self.currentlySelectedTagsList = tagsList
            if text!.isEmpty {
                self.suggestedTagTableView.removeFromSuperview()
            } else {
                let genres: [String] = self.possibleGenres.compactMap { (genre) -> String? in
                    if genre.lowercased().contains(text!.lowercased()) {
                        return genre
                    } else {
                        return nil
                    }
                }
                if genres.isEmpty == false {
                    self.tagSuggestions = genres
                }
            }
            print("Genre Text Changed")
        }
        
        gameModeTagsList.onDidChangeText = {tagsList, text in
            self.currentlySelectedTagsView = self.gameModeTagsView
            self.currentlySelectedTagsList = tagsList
            if text!.isEmpty {
                self.suggestedTagTableView.removeFromSuperview()
            } else {
                let gameModes: [String] = self.possiblePlayModes.compactMap { (gameMode) -> String? in
                    if gameMode.lowercased().contains(text!.lowercased()) {
                        return gameMode
                    } else {
                        return nil
                    }
                }
                if gameModes.isEmpty == false {
                    self.tagSuggestions = gameModes
                }
            }
            print("Game Mode Text Changed")
        }
        suggestedTagTableView.delegate = self
        suggestedTagTableView.dataSource = self
//        platformTagsList.inputFieldAccessoryView = toolBarView
//        genreTagsList.inputFieldAccessoryView = toolBarView
//        gameModeTagsList.inputFieldAccessoryView = toolBarView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
     }
    
   override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gameModeTagsList.frame = gameModeTagsView.bounds
        platformTagsList.frame = platformTagsView.bounds
        genreTagsList.frame = genreTagsView.bounds
    }

    // MARK: - Outlets
    
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet var toolBarView: UIView!
    @IBOutlet var suggestedTagTableView: UITableView!
    @IBOutlet weak var coverArtImageView: UIImageView!
    @IBOutlet weak var gameTitleTextField: UITextField!
    @IBOutlet weak var platformTagsView: UIView!
    @IBOutlet weak var genreTagsView: UIView!
    @IBOutlet weak var gameModeTagsView: UIView!
    @IBOutlet weak var playthroughHistoryBarButtonItem: UIBarButtonItem!
    
    // MARK: - Actions
    
    @IBAction func toolBarDoneButtonPressed(_ sender: Any) {
        suggestedTagTableView.removeFromSuperview()
        guard let selectedTagsList = currentlySelectedTagsList else { return }
        print("selectedTagsList is firstResponder: \(selectedTagsList.isFirstResponder)")
        if selectedTagsList.isFirstResponder == false{
            selectedTagsList.becomeFirstResponder()
        }
        selectedTagsList.endEditing()
        selectedTagsList.resignFirstResponder()
    }
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
        let platformIdPairs = platformTagsList.tags.map { (tag) -> (String,Int) in
            guard let platformId = GamePlatformController.shared.possiblePlatforms[tag.text] else {
                let platformsWithThisName = GamePlatformController.shared.platforms.filter { (gamePlatform) -> Bool in
                    gamePlatform.name == tag.text
                }
                if platformsWithThisName.isEmpty {
                    // Create a new one
                    let newPlatform = GamePlatformController.shared.createCustomPlatformNameIdPair(givenTitle: tag.text)
                    return newPlatform
                } else {
                    let existingId = Int(platformsWithThisName[0].id)
                    return (tag.text, existingId)
                }
            }
            return (tag.text, platformId)
        }
        let genreIdPairs = genreTagsList.tags.map { (tag) -> (String,Int) in
            guard let genreId = GameGenreController.shared.possibleGenres[tag.text] else {
                let genresWithThisName = GameGenreController.shared.genres.filter { (gameGenre) -> Bool in
                    gameGenre.name == tag.text
                }
                if genresWithThisName.isEmpty {
                    let newGenre = GameGenreController.shared.createNewGameGenreNameIdPair(givenTitle: tag.text)
                    return newGenre
                } else {
                    let existingId = Int(genresWithThisName[0].id)
                    return (tag.text, existingId)
                }
            }
            return (tag.text, genreId)
        }
        let playModeIdPairs = gameModeTagsList.tags.map { (tag) -> (String,Int) in
            guard let playModeId = PlayModeController.shared.possiblePlayModes[tag.text] else {
                let playModesWithThisName = PlayModeController.shared.playModes.filter { (playMode) -> Bool in
                    playMode.name == tag.text
                }
                if playModesWithThisName.isEmpty {
                    let newPlayMode = PlayModeController.shared.createCustomPlayModeNameIdPair(givenTitle: tag.text)
                    return newPlayMode
                } else {
                    let existingId = Int(playModesWithThisName[0].id)
                    return (tag.text, existingId)
                }
            }
            return (tag.text, playModeId)
        }
        print("Platforms: \(platformIdPairs.description)", "Genres: \(genreIdPairs.description)", "PlayModes: \(playModeIdPairs.description)")
        guard let title = gameTitleTextField.text, !gameTitleTextField.text!.isEmpty else { return }
        guard let currentlySavedGame = savedGame else {
            if imageHasChanged {
                SavedGameController.shared.createSavedGame(title: title,
                                                           image: coverArtImageView.image!,
                                                           platforms: platformIdPairs,
                                                           genres: genreIdPairs,
                                                           gameModes: playModeIdPairs)
            } else {
                SavedGameController.shared.createSavedGame(title: title,
                                                           image: UIImage(named: "defaultCoverImage")!,
                                                           platforms: platformIdPairs,
                                                           genres: genreIdPairs,
                                                           gameModes: playModeIdPairs)
            }
            
            self.navigationController?.popViewController(animated: true)
            return
        }
        SavedGameController.shared.updateSavedGame(newTitle: title,
                                                   newImage: coverArtImageView.image!,
                                                   newPlatforms: platformIdPairs,
                                                   newGenres: genreIdPairs,
                                                   newPlayModes: playModeIdPairs,
                                                   gameToUpdate: currentlySavedGame)
        self.navigationController?.popViewController(animated: true)
        }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        getImage()
    }
    
    // MARK: - Internal Methods
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        if genreTagsList.isFirstResponder || gameModeTagsList.isFirstResponder {
            if self.view.frame.origin.y.isLess(than: 0.0) == false {
                if self.view.frame.height < 640 {
                    self.view.frame.origin.y -= keyboardFrame.height - 50.0
                } else {
                    self.view.frame.origin.y -= keyboardFrame.height - 150.0
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        #warning("keyboard gets dismissed and now origin.y is 64")
        suggestedTagTableView.removeFromSuperview()
        if self.view.frame.height < 640 {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 64
            }
        } else if self.view.frame.height < 1100 {
            if self.view.frame.height < 900 {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 88
                }
            } else {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 70
                }
            }
        } else {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 74
            }
        }
    }
    
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
           }
       }
       
   private func updatePlatformTagsView() {
       if let platforms = gamePlatforms {
           for platform in platforms {
                switch platform.id {
                case 6:
                    platformTagsList.addTag("PC")
                case 18:
                    platformTagsList.addTag("NES")
                case 19:
                    platformTagsList.addTag("SNES")
                case 29:
                    platformTagsList.addTag("Sega Genesis")
                case 47:
                    platformTagsList.addTag(" Virtual Console")
                case 99:
                    platformTagsList.addTag("FAMICOM")
                default:
                    platformTagsList.addTag(platform.name)
                }
            }
        }
    }
    
   private func updateGenreTagsView() {
        if let genres = genres {
            for genre in genres {
                switch genre.id {
                case 8:
                    genreTagsList.addTag("Platformer")
                case 12:
                    genreTagsList.addTag("Role-playing")
                case 11:
                    genreTagsList.addTag("Real Time Strategy")
                case 16:
                    genreTagsList.addTag("Turn-based Strategy")
                default:
                    genreTagsList.addTag(genre.name)
                }
            }
        }
    }
    
    private func updateGameModeTagsView() {
        if let gameModes = gameModes {
            for mode in gameModes {
                switch mode.id {
                case 1:
                    gameModeTagsList.addTag("Single Player")
                case 4:
                    gameModeTagsList.addTag("Split Screen")
                case 5:
                    gameModeTagsList.addTag("Massively Multiplayer Online")
                default:
                    gameModeTagsList.addTag(mode.name)
                }
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
        imageHasChanged = true
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
    
    private func setupColorsBasedOnDarkMode() {
        switch self.traitCollection.userInterfaceStyle {
        case .dark:
            platformTagsList.fieldTextColor = .white
            genreTagsList.fieldTextColor = .white
            gameModeTagsList.fieldTextColor = .white
        case .light:
            platformTagsList.fieldTextColor = .black
            genreTagsList.fieldTextColor = .black
            gameModeTagsList.fieldTextColor = .black
        default:
            return
        }
    }
    
    private func resignFirstResponderTapRecongnizerSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        suggestedTagTableView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.view.addGestureRecognizer(tap)
   }
    
    private func accountForCustomTags() {
        let uniquePlatformNames = GamePlatformController.shared.platforms.map { (platform) -> String in
            return platform.name!
        }.uniques
        let uniqueGenreNames = GameGenreController.shared.genres.map { (genre) -> String in
            return genre.name!
        }.uniques
        let uniquePlayModeNames = PlayModeController.shared.playModes.map { (playMode) -> String in
            return playMode.name!
        }.uniques
        for platform in uniquePlatformNames {
            if GamePlatformController.shared.possiblePlatforms[platform] == nil {
                possiblePlatforms.append(platform)
            }
        }
        for genre in uniqueGenreNames {
            if GameGenreController.shared.possibleGenres[genre] == nil {
                possibleGenres.append(genre)
            }
        }
        for playMode in uniquePlayModeNames {
            if PlayModeController.shared.possiblePlayModes[playMode] == nil {
                possiblePlayModes.append(playMode)
            }
        }
    }
}

// MARK: - ImagePicker Delegation

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
        imageHasChanged = true
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Navigation

extension GameDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowHistory" {
            guard let historyVC = segue.destination as? PlaythroughHistoryListTableViewController, let selectedGame = savedGame else { return }
            historyVC.savedGame = selectedGame
        }
    }
}
