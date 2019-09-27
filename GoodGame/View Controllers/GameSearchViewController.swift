//
//  ViewController.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GameSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = gameSearchBar.text, gameSearchBar.text?.isEmpty == false else {
            return
        }
        GameController.shared.searchByGameName(searchText) { (games) in
            self.retreivedGames = games
        }
    }
    
    
    // MARK: - TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let games = retreivedGames else { return 0 }
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell"), let games = retreivedGames else { return UITableViewCell() }
        let gameForCell = games[indexPath.row]
        cell.textLabel?.text = gameForCell.name
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let games = retreivedGames else { return }
        let selectedGame = games[indexPath.row]
        print(selectedGame.cover)
        selectedVideoGame = selectedGame
        self.performSegue(withIdentifier: "toShowGame", sender: self)
    }
    
    // MARK: - Internal Properties
    
    var selectedVideoGame: Game?
    var retreivedGames: [Game]? {
        didSet {
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
            }
        }
    }
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchbar()
        setupTableView()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameSearchBar: UISearchBar!
    @IBOutlet weak var searchResultsTableView: UITableView!
    
    // MARK: - Internal Methods
    
    private func setupSearchbar() {
        gameSearchBar.delegate = self
    }
    
    private func setupTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowGame" {
            guard let detailVC = segue.destination as? GameDetailViewController, let game = selectedVideoGame else { return }
            detailVC.gameId = game.id
            detailVC.game = game
        }
    }

}

