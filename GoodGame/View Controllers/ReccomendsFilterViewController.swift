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
    var genresNames: [String] {
        get {
            var genreNames: [String] = []
            for genre in GameGenreController.shared.genres {
                if let genreName = genre.name {
                    if !genreNames.contains(genreName) {
                         genreNames.append(genreName)
                    }
                }
            }
            return genreNames
        }
    }
    var selectedGenreName: String = ""
    var platformNames: [String] {
        get {
            var platformNames: [String] = []
            for platform in GamePlatformController.shared.platforms {
                if let platformName = platform.name {
                    if !platformNames.contains(platformName) {
                        platformNames.append(platformName)
                    }
                }
            }
            return platformNames
        }
    }
    var selectedPlatformName: String = ""
    var playModeNames: [String] {
        get {
            var playModeNames: [String] = []
            for playMode in PlayModeController.shared.playModes {
                if let playModeName = playMode.name {
                    if !playModeNames.contains(playModeName) {
                        playModeNames.append(playModeName)
                    }
                }
            }
            return playModeNames
        }
    }
    var selectedPlayModeName: String = ""
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
        #warning("if the string is empty -- pass in nil for fetch predicate (i.e return whole collection)")
        var platformSavedGames = [SavedGame]()
        var genreSavedGames = [SavedGame]()
        var playModeSavedGames = [SavedGame]()
        if selectedPlatformName.isEmpty {
            platformSavedGames = SavedGameController.shared.savedGames
        } else {
            platformSavedGames = GamePlatformController.shared.loadSavedGamesFromPlatform(platformName: selectedPlatformName)
        }
        if selectedGenreName.isEmpty {
            genreSavedGames = SavedGameController.shared.savedGames
        } else {
            genreSavedGames = GameGenreController.shared.loadSavedGamesBasedOnGenreName(genreName: selectedGenreName)
        }
        if selectedPlayModeName.isEmpty {
            playModeSavedGames = SavedGameController.shared.savedGames
        } else {
            playModeSavedGames = PlayModeController.shared.loadSavedGamesBasedOnPlayModeNames(playModeName: selectedPlayModeName)
        }
        let commonSavedGames = Array(Set(platformSavedGames).intersection(Set(genreSavedGames)).intersection(Set(playModeSavedGames)))
        if commonSavedGames.isEmpty {
            let noGamesFoundAlert = UIAlertController(title: "No Games Found", message: "The selected filters don't match any games in your library. Please try other filter combinations.", preferredStyle: .alert)
            noGamesFoundAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(noGamesFoundAlert, animated: true, completion: nil)
        } else {
            filteredGames = commonSavedGames
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case platformsTableView:
            return platformNames.count
        case genresTableView:
            return genresNames.count
        case gameModesTableView:
            return playModeNames.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkableCell") as? CheckableTableViewCell else { return UITableViewCell() }
        switch tableView {
        case platformsTableView:
            let platformName = platformNames[indexPath.row]
            cell.mainLabel?.text = platformName
            return cell
        case genresTableView:
            let genreName = genresNames[indexPath.row]
            cell.mainLabel?.text = genreName
            return cell
        case gameModesTableView:
            let playModeName = playModeNames[indexPath.row]
            cell.mainLabel?.text = playModeName
            return cell
        default:
            return cell
        }
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case platformsTableView:
            // check if isSelected from the cell? -- first tap adds the name, second tap removes it
            let selectedPlatformName = platformNames[indexPath.row]
            self.selectedPlatformName = selectedPlatformName
        case genresTableView:
            let selectedGenreName = genresNames[indexPath.row]
            self.selectedGenreName = selectedGenreName
        case gameModesTableView:
            let selectedPlayModeName = playModeNames[indexPath.row]
            self.selectedPlayModeName = selectedPlayModeName
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
