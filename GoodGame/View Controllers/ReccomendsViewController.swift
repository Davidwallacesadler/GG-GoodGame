//
//  ReccomendsViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/20/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class ReccomendsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Internal Properties
    
    var randomPlatformName: String {
        get {
            guard let randomPlatform = GamePlatformController.shared.platforms.randomElement() else { return "" }
            guard let randomPlatformName = randomPlatform.name else { return "" }
            return randomPlatformName
        }
    }
    var platformName: String?
    var randomGenreName: String {
        get {
            guard let randomGenre = GameGenreController.shared.genres.randomElement() else { return "" }
            guard let randomGenreName = randomGenre.name else { return "" }
            return randomGenreName
        }
    }
    var genreName: String?
    var gamesAssociatedWithRandomPlatform: [SavedGame] = []
    var gamesAssociatedWithRandomGenre: [SavedGame] = []
    var currentlyPlayingGames: [SavedGame] {
        get {
            var currentlyPlayingGames: [SavedGame] = []
            for savedGame in SavedGameController.shared.savedGames {
                if savedGame.isBeingCurrentlyPlayed {
                    currentlyPlayingGames.append(savedGame)
                }
            }
            return currentlyPlayingGames
        }
    }
    private let spacing: CGFloat = 16.0
    var selectedSavedGame: SavedGame? {
        didSet {
            self.performSegue(withIdentifier: "toShowPlayStatus", sender: self)
        }
    }
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareRandomGenreAndPlatformData()
        setupCollectionViewDataSourceAndDelegation()
        registerCustomCollectionViewCells()
        setupCollectionViewFlowLayouts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recentlyPlayedCollectionView.reloadData()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var randomGenreLabel: UILabel!
    @IBOutlet weak var randomPlatformLabel: UILabel!
    @IBOutlet weak var recentlyPlayedCollectionView: UICollectionView!
    @IBOutlet weak var randomPlatformCollectionView: UICollectionView!
    @IBOutlet weak var randomGenreCollectionView: UICollectionView!
    
    // MARK: - CollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case recentlyPlayedCollectionView:
            return currentlyPlayingGames.count
        case randomPlatformCollectionView:
            return gamesAssociatedWithRandomPlatform.count
        case randomGenreCollectionView:
            return gamesAssociatedWithRandomGenre.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "squareImageCell", for: indexPath) as? SquareImageCollectionViewCell else { return UICollectionViewCell() }
        switch collectionView {
        case recentlyPlayedCollectionView:
            let currentlyPlayingSavedGame = currentlyPlayingGames[indexPath.row]
            cell.mainImageView.image = currentlyPlayingSavedGame.photo
            cell.mainLabel.text = currentlyPlayingSavedGame.title
            return cell
        case randomPlatformCollectionView:
            let savedGameByPlatform = gamesAssociatedWithRandomPlatform[indexPath.row]
            cell.mainImageView.image = savedGameByPlatform.photo
            cell.mainLabel.text = savedGameByPlatform.title
            return cell
        case randomGenreCollectionView:
            let savedGameByGenre = gamesAssociatedWithRandomGenre[indexPath.row]
            cell.mainImageView.image = savedGameByGenre.photo
            cell.mainLabel.text = savedGameByGenre.title
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    // MARK: - CollectionView Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case recentlyPlayedCollectionView:
            let selectedGame = currentlyPlayingGames[indexPath.row]
            self.selectedSavedGame = selectedGame
        case randomPlatformCollectionView:
            let selectedGame = gamesAssociatedWithRandomPlatform[indexPath.row]
            self.selectedSavedGame = selectedGame
        case randomGenreCollectionView:
            let selectedGame = gamesAssociatedWithRandomGenre[indexPath.row]
            self.selectedSavedGame = selectedGame
        default:
            return
        }
    }
    
    // MARK: - Internal Methods
    
    private func getGamesForPlatform() {
        gamesAssociatedWithRandomPlatform = GamePlatformController.shared.loadSavedGamesFromPlatform(platformName: platformName!)
    }
    
    private func getGamesForGenre() {
        gamesAssociatedWithRandomGenre = GameGenreController.shared.loadSavedGamesBasedOnGenreName(genreName: genreName!)
    }
    
    private func setupCollectionViewDataSourceAndDelegation() {
        self.recentlyPlayedCollectionView.delegate = self
        self.recentlyPlayedCollectionView.dataSource = self
        self.randomPlatformCollectionView.delegate = self
        self.randomPlatformCollectionView.dataSource = self
        self.randomGenreCollectionView.delegate = self
        self.randomGenreCollectionView.dataSource = self
    }
    
    private func registerCustomCollectionViewCells() {
        self.recentlyPlayedCollectionView.register(UINib(nibName: "SquareImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "squareImageCell")
        self.randomPlatformCollectionView.register(UINib(nibName: "SquareImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "squareImageCell")
        self.randomGenreCollectionView.register(UINib(nibName: "SquareImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "squareImageCell")
    }
    
    private func prepareRandomGenreAndPlatformData() {
        platformName = randomPlatformName
        genreName = randomGenreName
        if let platform = platformName, let genre = genreName {
            if platform.isEmpty && genre.isEmpty {
                randomPlatformLabel.text = "Random Platform"
                randomGenreLabel.text = "Random Genre"
            } else {
                randomPlatformLabel.text = "\(platform) Games"
                randomGenreLabel.text = "\(genre) Games"
                getGamesForGenre()
                getGamesForPlatform()
            }
        }
    }
    
    private func setupCollectionViewFlowLayouts() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.recentlyPlayedCollectionView.frame.width / 1.5, height: self.recentlyPlayedCollectionView.frame.height)
        //layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        self.recentlyPlayedCollectionView.collectionViewLayout = layout
        self.randomPlatformCollectionView.collectionViewLayout = layout
        self.randomGenreCollectionView.collectionViewLayout = layout
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowPlayStatus" {
            guard let playStatusVC = segue.destination as? PlayStatusViewController, let savedGame = selectedSavedGame else { return }
            slideInTransitioningDelegate.direction = .bottom
            playStatusVC.transitioningDelegate = slideInTransitioningDelegate
            playStatusVC.modalPresentationStyle = .custom
            playStatusVC.selectedGame = savedGame
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout

//extension ReccomendsViewController: UICollectionViewDelegateFlowLayout {
//func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let numberOfItemsPerRow: CGFloat = 2
//    let spacingBetweenCells: CGFloat = 16
//    let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
//    let width = (self.view.bounds.width - totalSpacing)/numberOfItemsPerRow
//    let height = collectionView.bounds.height
//    return CGSize(width: height, height: width)
//    }
//}
