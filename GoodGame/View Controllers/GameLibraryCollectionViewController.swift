//
//  GameLibraryCollectionViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "savedGameCell"

class GameLibraryCollectionViewController: UICollectionViewController, CollectionViewCellLongTouchDelegate {
    
    // MARK: - CollectionViewCellLongTouchDelegate
    
    func didLongPress(index: IndexPath, sectionKey: String) {
        guard let gamesBasedOnCharacter = savedGamesOrdered[sectionKey] else { return }
        let selectedGame = gamesBasedOnCharacter[index.row]
        selectedSavedGame = selectedGame
        self.performSegue(withIdentifier: "toShowPlayStatus", sender: self)
    }
    
    // MARK: - Actions

    #warning("maybe implement filtering here in the future - but for now just keep it alphabetical")
    @IBAction func filterButtonTapped(_ sender: Any) {
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewInsets()
        setupCollectionViewDelegation()
        registerCustomCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    // MARK: - Internal Properties
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    private let spacing: CGFloat = 16.0
    var selectedSavedGame: SavedGame?
    var savedGamesOrdered: [String : [SavedGame]] {
        get {
            return SavedGameController.shared.savedGames.groupedByFirstTitleLetterString()
        }
    }
    var groupingKeys: [String] {
        var grouping = [String]()
        for key in savedGamesOrdered.keys {
            grouping.append(key)
        }
        return grouping.sorted(by: <)
    }
    let filterTitles = ["Alphabetical", "By Favorites", " By Games Completed", "By Genre", "By Platform"]
    
    // MARK: - Internal Methods
    
    private func setupCollectionViewInsets() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 30)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
     }
    
     private func setupCollectionViewDelegation() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
     }
    
     private func registerCustomCells() {
        self.collectionView!.register(UINib(nibName: "SavedGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UINib(nibName: "SectionHeader", bundle: nil), forCellWithReuseIdentifier: "sectionHeader")
     }

    // MARK: - UICollectionViewDataSource
    
    #warning("I want sections to be alphebetical")
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupingKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionHeader", for: indexPath) as? SectionHeader {
            sectionHeader.mainLabel.text = groupingKeys[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let firstLetterKey = groupingKeys[section]
        guard let groupingCount = savedGamesOrdered[firstLetterKey]?.count else { return 0 }
        return groupingCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedGameCollectionViewCell else { return UICollectionViewCell() }
        let alphaKey = groupingKeys[indexPath.section]
        if let gameGrouping = savedGamesOrdered[alphaKey] {
            let savedGame = gameGrouping[indexPath.row]
            gameCell.coverImageView.image = savedGame.photo
            gameCell.gameTitleLabel.text = savedGame.title
            gameCell.delegate = self
            gameCell.indexPath = indexPath
            gameCell.sectionKey = alphaKey
        }
        return gameCell
    }

    // MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alphaKey = groupingKeys[indexPath.section]
        guard let gameCollection = savedGamesOrdered[alphaKey] else { return }
        let saveGame = gameCollection[indexPath.row]
        selectedSavedGame = saveGame
        self.performSegue(withIdentifier: "toShowSavedGame", sender: self)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowSavedGame" {
            guard let detailVC = segue.destination as? GameDetailViewController, let savedGame = selectedSavedGame else { return }
            detailVC.savedGame = savedGame
        } else if segue.identifier == "toShowPlayStatus" {
            guard let playStatusVC = segue.destination as? PlayStatusViewController, let savedGame = selectedSavedGame else { return }
            slideInTransitioningDelegate.direction = .bottom
            playStatusVC.transitioningDelegate = slideInTransitioningDelegate
            playStatusVC.modalPresentationStyle = .custom
            playStatusVC.selectedGame = savedGame
        }
    }
}

// MARK: - CollectionView Flow

extension GameLibraryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenCells: CGFloat = 20
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width + (width / 4.0))
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
}
