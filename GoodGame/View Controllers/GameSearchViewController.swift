//
//  ViewController.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GameSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    #warning("Maybe perform the netowrk call on textFieldDidAddText or something - so the list is getting updated as the user is inputing text")
    // MARK: - SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = gameSearchBar.text, gameSearchBar.text?.isEmpty == false else {
            self.loadingImageView?.stopAnimating()
            self.loadingImageView?.removeFromSuperview()
            searchBar.resignFirstResponder()
            return
        }
        GameController.shared.searchByGameName(searchText) { (games) in
            self.retreivedGames = games
        }
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.view.addSubview(loadingImageView!)
        loadingImageView?.startAnimating()
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        self.perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 0.75)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.retreivedGames = []
        self.searchResultsTableView.reloadData()    
        searchBar.resignFirstResponder()
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        if query.isEmpty {
            self.loadingImageView?.stopAnimating()
            self.loadingImageView?.removeFromSuperview()
            print("Nothing to search")
            return
        } else {
            print("Performing network request with query: \(query)")
            GameController.shared.searchByGameName(query) { (games) in
                self.retreivedGames = games
            }
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
        selectedVideoGame = selectedGame
        gameSearchBar.resignFirstResponder()
    }
    
    // MARK: - Internal Properties
    
    let loadingImages = (1...8).map { (i) -> UIImage in
        return UIImage(named: "\(i)")!
    }
    var loadingImageView: UIImageView?
    
    var selectedVideoGame: Game? {
        didSet {
            getGameArtwork()
        }
    }
    var selectedGameArtwork: [Artwork]? {
        didSet {
            DispatchQueue.main.async {
                 self.performSegue(withIdentifier: "toShowGame", sender: self)
            }
        }
    }
    var retreivedGames: [Game]? {
        didSet {
            DispatchQueue.main.async {
                self.searchResultsTableView.reloadData()
                self.loadingImageView?.stopAnimating()
                self.loadingImageView?.removeFromSuperview()
            }
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchbar()
        setupTableView()
        resignFirstResponderTapRecongnizerSetup()
        loadingImageView = UIImageView(frame: CGRect(x: (view.bounds.width / 2.0) - ((view.bounds.width / 5.0)) / 2.0, y: (view.bounds.height / 3.0) - ((view.bounds.width / 5.0)) / 2.0, width: view.bounds.width / 5.0, height: view.bounds.width / 5.0))
        loadingImageView!.animationImages = loadingImages
        loadingImageView!.animationDuration = 1.0
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
    
    private func getGameArtwork() {
       guard let game = selectedVideoGame else { return }
       GameController.shared.getCoverArtworkByGameId(game.id) { (artworks) in
           self.selectedGameArtwork = artworks
       }
    }
    
    private func resignFirstResponderTapRecongnizerSetup() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowGame" {
            guard let detailVC = segue.destination as? GameDetailViewController, let game = selectedVideoGame, let artworks = selectedGameArtwork else { return }
            detailVC.artworks = artworks
            detailVC.gameId = game.id
            detailVC.gamePlaftormIds = game.platforms
            detailVC.genreIds = game.genres
            detailVC.gameModeIds = game.game_modes
            detailVC.game = game
        }
    }

}

