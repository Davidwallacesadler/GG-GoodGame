//
//  ReccomendsFilterViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/20/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class ReccomendsFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Internal Properties
    #warning("cast genre names as a set to solve unqiueness problem")
    var genresNamesIdPairs: [(String,Int)] {
        get {
            var addedNames: Set<String> = []
            return GameGenreController.shared.genres.compactMap { (gameGenre) -> (String,Int)? in
                if let genreName = gameGenre.name {
                    if !addedNames.contains(genreName) {
                        addedNames.insert(genreName)
                        return (genreName, Int(gameGenre.id))
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        }
    }
    var selectedGenreIds: [Int] = []
    var platformNameIdParis: [(String,Int)] {
        get {
            var addedNames: Set<String> = []
            return GamePlatformController.shared.platforms.compactMap { (gamePlatform) -> (String,Int)? in
                if let platformName = gamePlatform.name {
                    if !addedNames.contains(platformName) {
                        addedNames.insert(platformName)
                        return (platformName, Int(gamePlatform.id))
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        }
    }
    var selectedPlatformIds: [Int] = []
    var playModeNameIdPairs: [(String,Int)] {
        get {
            var addedNames: Set<String> = []
            return PlayModeController.shared.playModes.compactMap { (playMode) -> (String,Int)? in
                if let playModeName = playMode.name {
                    if !addedNames.contains(playModeName) {
                        addedNames.insert(playModeName)
                        return (playModeName, Int(playMode.id))
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            }
        }
    }
    var selectedPlayModeIds: [Int] = []
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var filteredGame: SavedGame? {
        didSet {
            self.performSegue(withIdentifier: "toShowFilteredGame", sender: self)
        }
    }
    var filteredGames: [SavedGame]? {
        didSet {
            self.performSegue(withIdentifier: "toShowFilteredGames", sender: self)
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegation()
        roundTableViewCorners()
        registerCustomCells()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var platformsTableView: UITableView!
    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var gameModesTableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        // Apply Filter and get a random element from the collection
        var platformSavedGames = [SavedGame]()
        var genreSavedGames = [SavedGame]()
        var playModeSavedGames = [SavedGame]()
        if selectedPlatformIds.isEmpty && selectedGenreIds.isEmpty && selectedPlayModeIds.isEmpty {
            let noGamesFoundAlert = UIAlertController(title: "No Games Found", message: "Please select at least one name from the filter lists to get results.", preferredStyle: .alert)
            noGamesFoundAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noGamesFoundAlert, animated: true, completion: nil)
        }
        if selectedPlatformIds.isEmpty {
            platformSavedGames = SavedGameController.shared.savedGames
        } else {
            let platformPredicateString = createPredicateString(givenIdArray: selectedPlatformIds)
            platformSavedGames = GamePlatformController.shared.fetchSavedGameFromPlatformPredicateString(predicateString: platformPredicateString)
        }
        if selectedGenreIds.isEmpty {
            genreSavedGames = SavedGameController.shared.savedGames
        } else {
            let genrePredicateString = createPredicateString(givenIdArray: selectedGenreIds)
            genreSavedGames = GameGenreController.shared.fetchSavedGameFromGenrePredicateString(predicateString: genrePredicateString)
        }
        if selectedPlayModeIds.isEmpty {
            playModeSavedGames = SavedGameController.shared.savedGames
        } else {
            let playModePredicateString = createPredicateString(givenIdArray: selectedPlayModeIds)
            playModeSavedGames = PlayModeController.shared.fetchSavedGameFromPlayModePredicateString(predicateString: playModePredicateString)
        }
        let commonSavedGames = Array(Set(platformSavedGames).intersection(Set(genreSavedGames)).intersection(Set(playModeSavedGames)))
        if commonSavedGames.isEmpty {
            presentNoGamesFoundAlert()
        } else {
            filteredGames = commonSavedGames
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case platformsTableView:
            return platformNameIdParis.count
        case genresTableView:
            return genresNamesIdPairs.count
        case gameModesTableView:
            return playModeNameIdPairs.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkableCell") as? CheckableTableViewCell else { return UITableViewCell() }
        switch tableView {
        case platformsTableView:
            let platformName = platformNameIdParis[indexPath.row].0
            cell.mainLabel?.text = platformName
            return cell
        case genresTableView:
            let genreName = genresNamesIdPairs[indexPath.row].0
            cell.mainLabel?.text = genreName
            return cell
        case gameModesTableView:
            let playModeName = playModeNameIdPairs[indexPath.row].0
            cell.mainLabel?.text = playModeName
            return cell
        default:
            return cell
        }
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CheckableTableViewCell else { return }
        cell.setSelected(cell.isSelected, animated: true)
        switch tableView {
        case platformsTableView:
            let selectedPlatformId = platformNameIdParis[indexPath.row].1
            selectedPlatformIds.append(selectedPlatformId)
            print("Currently selected platforms = \(selectedPlatformIds.description)")
        case genresTableView:
            let selectedGenreId = genresNamesIdPairs[indexPath.row].1
            selectedGenreIds.append(selectedGenreId)
            print("Currently selected genres = \(selectedGenreIds.description)")
        case gameModesTableView:
            let selectedPlayModeId = playModeNameIdPairs[indexPath.row].1
            selectedPlayModeIds.append(selectedPlayModeId)
            print("Currently selected playModes = \(selectedPlayModeIds.description)")
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CheckableTableViewCell else { return }
        cell.setSelected(cell.isSelected, animated: true)
        switch tableView {
        case platformsTableView:
            let selectedPlatformId = platformNameIdParis[indexPath.row].1
            guard let indexOfId = selectedPlatformIds.firstIndex(of: selectedPlatformId) else { return }
            selectedPlatformIds.remove(at: indexOfId)
            print("Currently selected platforms = \(selectedPlatformIds.description)")
        case genresTableView:
            let selectedGenreId = genresNamesIdPairs[indexPath.row].1
            guard let indexOfId = selectedGenreIds.firstIndex(of: selectedGenreId) else { return }
            selectedGenreIds.remove(at: indexOfId)
            print("Currently selected genres = \(selectedGenreIds.description)")
        case gameModesTableView:
            let selectedPlayModeId = playModeNameIdPairs[indexPath.row].1
            guard let indexOfId = selectedPlayModeIds.firstIndex(of: selectedPlayModeId) else { return }
            selectedPlayModeIds.remove(at: indexOfId)
            print("Currently selected playModes = \(selectedPlayModeIds.description)")
        default:
            return
        }
    }
    
    // MARK: - Internal Methods
    
    private func setupTableViewDelegation() {
        platformsTableView.dataSource = self
        genresTableView.dataSource = self
        gameModesTableView.dataSource = self
        platformsTableView.delegate = self
        genresTableView.delegate = self
        gameModesTableView.delegate = self
    }
    
    private func roundTableViewCorners() {
        ViewHelper.roundCornersOf(viewLayer: platformsTableView.layer, withRoundingCoefficient: 15.0)
        ViewHelper.roundCornersOf(viewLayer: genresTableView.layer, withRoundingCoefficient: 15.0)
        ViewHelper.roundCornersOf(viewLayer: gameModesTableView.layer, withRoundingCoefficient: 15.0)
    }
    
    private func registerCustomCells() {
        platformsTableView.register(UINib(nibName: "CheckableTableViewCell", bundle: nil), forCellReuseIdentifier: "checkableCell")
        genresTableView.register(UINib(nibName: "CheckableTableViewCell", bundle: nil), forCellReuseIdentifier: "checkableCell")
        gameModesTableView.register(UINib(nibName: "CheckableTableViewCell", bundle: nil), forCellReuseIdentifier: "checkableCell")
    }
    
//    private func createPredicateString(givenNameArray: [String]) -> String {
//        var predicateString = ""
//        if givenNameArray.count == 1 {
//            let nameEscaped = #""\#(givenNameArray[0])""#
//            predicateString = "name == \(nameEscaped)"
//        } else {
//            for i in 0..<givenNameArray.count {
//                let name = givenNameArray[i]
//                let nameChunk = #""\#(name)""#
//                var predicateChunk = ""
//                if i < (givenNameArray.count - 1) {
//                    predicateChunk = "(name == \(nameChunk)) OR "
//                } else {
//                    predicateChunk = "(name == \(nameChunk))"
//                }
//                predicateString.append(predicateChunk)
//            }
//        }
//        return predicateString
//    }
    
    private func createPredicateString(givenIdArray: [Int]) -> String {
       var predicateString = ""
       if givenIdArray.count == 1 {
           predicateString = "id == \(givenIdArray[0])"
       } else {
           for i in 0..<givenIdArray.count {
               let id = givenIdArray[i]
               var predicateChunk = ""
               if i < (givenIdArray.count - 1) {
                   predicateChunk = "(id == \(id)) OR "
               } else {
                   predicateChunk = "(id == \(id))"
               }
               predicateString.append(predicateChunk)
           }
       }
       return predicateString
   }
    
    private func presentNoGamesFoundAlert() {
        let noGamesFoundAlert = UIAlertController(title: "No Games Found", message: "None of the selected filters match any games in your library. Please try other filter combinations.", preferredStyle: .alert)
        noGamesFoundAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(noGamesFoundAlert, animated: true, completion: nil)
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowFilteredGame" {
            guard let playStatusVC = segue.destination as? PlayStatusViewController, let selectedGame = filteredGame else { return }
            slideInTransitioningDelegate.direction = .bottom
            playStatusVC.transitioningDelegate = slideInTransitioningDelegate
            playStatusVC.modalPresentationStyle = .custom
            playStatusVC.selectedGame = selectedGame
        } else if segue.identifier == "toShowFilteredGames" {
            guard let filteredGamesVC = segue.destination as? FilteredGamesListCollectionViewController, let selectedGames = filteredGames else { return }
            filteredGamesVC.savedGames = selectedGames
        }
    }
}
