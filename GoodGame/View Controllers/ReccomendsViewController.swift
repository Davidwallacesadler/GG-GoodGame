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
    
    var randomPlatformNameIdPair: (String,Int) {
        get {
            guard let randomPlatform = GamePlatformController.shared.platforms.randomElement() else { return ("",0) }
            guard let randomPlatformName = randomPlatform.name else { return ("",0) }
            return (randomPlatformName, Int(randomPlatform.id))
        }
    }
    var platformName: String?
    var randomGenreNameIdPair: (String,Int) {
        get {
            guard let randomGenre = GameGenreController.shared.genres.randomElement() else { return ("",0) }
            guard let randomGenreName = randomGenre.name else { return ("",0) }
            return (randomGenreName, Int(randomGenre.id))
        }
    }
    var genreName: String?
    var gamesAssociatedWithRandomPlatform: [SavedGame] = []
    var gamesAssociatedWithRandomGenre: [SavedGame] = []
    var currentlyPlayingGames: [SavedGame] {
        return SavedGameController.shared.loadCurrentlyPlayingGames()
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
    
    #warning("need to have an observer to reload this collectionview whenever the view comes back")
    override func viewDidAppear(_ animated: Bool) {
        #warning("Want to reload the recently played when we come back from the playStatusVC")
        self.recentlyPlayedCollectionView.reloadData()
        if gamesAssociatedWithRandomPlatform.isEmpty || gamesAssociatedWithRandomGenre.isEmpty {
            self.prepareRandomGenreAndPlatformData()
        }
        let clearView = UIView(frame: recentlyPlayedCollectionView.bounds)
        clearView.tintColor = .clear
        if currentlyPlayingGames.isEmpty {
           let noGamesFoundImageView = UIImageView(image: UIImage(named: "startAGameIcon"))
           noGamesFoundImageView.contentMode = .scaleAspectFit
           recentlyPlayedCollectionView.backgroundView = noGamesFoundImageView
        } else if currentlyPlayingGames.isEmpty == false {
            recentlyPlayedCollectionView.backgroundView = clearView
        } else if gamesAssociatedWithRandomGenre.isEmpty == false {
            randomGenreCollectionView.backgroundView = clearView
        } else if gamesAssociatedWithRandomPlatform.isEmpty == false {
            randomPlatformCollectionView.backgroundView = clearView
        }
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
        let predicateString = "id == \(randomPlatformNameIdPair.1)"
        gamesAssociatedWithRandomPlatform = GamePlatformController.shared.fetchSavedGameFromPlatformPredicateString(predicateString: predicateString)
        randomPlatformCollectionView.reloadData()
    }
    
    private func getGamesForGenre() {
        let predicateString = "id == \(randomGenreNameIdPair.1)"
        gamesAssociatedWithRandomGenre = GameGenreController.shared.fetchSavedGameFromGenrePredicateString(predicateString: predicateString)
        randomGenreCollectionView.reloadData()
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
        platformName = randomPlatformNameIdPair.0
        genreName = randomGenreNameIdPair.0
        if let platform = platformName, let genre = genreName {
            if platform.isEmpty && genre.isEmpty {
                randomPlatformLabel.text = "Random Platform Games"
                randomGenreLabel.text = "Random Genre Games"
                let noGamesFoundImageView = UIImageView(image: UIImage(named: "noGamesFoundIcon"))
                let noGamesFoundImageViewTwo = UIImageView(image: UIImage(named: "noGamesFoundIcon"))
                noGamesFoundImageView.contentMode = .scaleAspectFit
                noGamesFoundImageViewTwo.contentMode = .scaleAspectFit
                randomPlatformCollectionView.backgroundView = noGamesFoundImageView
                randomGenreCollectionView.backgroundView = noGamesFoundImageViewTwo
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
        
        let layoutTwo = UICollectionViewFlowLayout()
        layoutTwo.itemSize = CGSize(width: self.randomPlatformCollectionView.frame.width / 1.5, height: self.randomPlatformCollectionView.frame.height)
        //layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layoutTwo.minimumLineSpacing = spacing
        layoutTwo.minimumInteritemSpacing = spacing
        layoutTwo.scrollDirection = .horizontal
        
        let layoutThree = UICollectionViewFlowLayout()
        layoutThree.itemSize = CGSize(width: self.randomGenreCollectionView.frame.width / 1.5, height: self.randomGenreCollectionView.frame.height)
        //layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layoutThree.minimumLineSpacing = spacing
        layoutThree.minimumInteritemSpacing = spacing
        layoutThree.scrollDirection = .horizontal
        
        
        self.recentlyPlayedCollectionView.collectionViewLayout = layout
        self.randomPlatformCollectionView.collectionViewLayout = layoutTwo
        self.randomGenreCollectionView.collectionViewLayout = layoutThree
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

extension ReccomendsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 2
        let spacingBetweenCells: CGFloat = 16
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        let height = collectionView.bounds.height
        return CGSize(width: height, height: width)
    }
}
