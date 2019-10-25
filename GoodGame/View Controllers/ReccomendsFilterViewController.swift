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
    var selectedGenreNames: Set<String> = []
    var possibleGenreGames: Set<SavedGame> = []
    
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
    var selectedPlatformNames: Set<String> = []
    var possiblePlatformGames: Set<SavedGame> = []
    
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
    var selectedPlayModeNames: Set<String> = []
    var possiblePlayModeGames: Set<SavedGame> = []
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var filteredGame: SavedGame? {
        didSet {
            self.performSegue(withIdentifier: "toShowFilteredGame", sender: self)
        }
    }
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegation()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var platformsTableView: UITableView!
    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var gameModesTableView: UITableView!
    
    // MARK: - Actions
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        // Apply Filter and get a random element from the collection
        #warning("this is super basic and just works for now -- need to come up with a better filtering method")
        for platform in GamePlatformController.shared.platforms {
            if selectedPlatformNames.contains(platform.name!) {
                possiblePlatformGames.insert(platform.savedGame!)
            }
        }
        for genre in GameGenreController.shared.genres {
            if selectedGenreNames.contains(genre.name!) {
                possibleGenreGames.insert(genre.savedGame!)
            }
        }
        for playMode in PlayModeController.shared.playModes {
            if selectedPlayModeNames.contains(playMode.name!) {
                possiblePlayModeGames.insert(playMode.savedGame!)
            }
        }
        let finalSet = possibleGenreGames.intersection(possiblePlatformGames).intersection(possiblePlayModeGames)
        guard let randomGameFromFilter = finalSet.randomElement() else { return }
        filteredGame = randomGameFromFilter
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        switch tableView {
        case platformsTableView:
            let platformName = platformNames[indexPath.row]
            cell.textLabel?.text = platformName
            return cell
        case genresTableView:
            let genreName = genresNames[indexPath.row]
            cell.textLabel?.text = genreName
            return cell
        case gameModesTableView:
            let playModeName = playModeNames[indexPath.row]
            cell.textLabel?.text = playModeName
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
            selectedPlatformNames.insert(selectedPlatformName)
        case genresTableView:
            let selectedGenreName = genresNames[indexPath.row]
            selectedGenreNames.insert(selectedGenreName)
        case gameModesTableView:
            let selectedPlayModeName = playModeNames[indexPath.row]
            selectedPlayModeNames.insert(selectedPlayModeName)
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
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowFilteredGame" {
            guard let playStatusVC = segue.destination as? PlayStatusViewController, let selectedGame = filteredGame else { return }
            slideInTransitioningDelegate.direction = .bottom
            playStatusVC.transitioningDelegate = slideInTransitioningDelegate
            playStatusVC.modalPresentationStyle = .custom
            playStatusVC.selectedGame = selectedGame
        }
    }
}
