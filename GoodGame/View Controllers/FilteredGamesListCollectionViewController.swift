//
//  FilteredGamesListCollectionViewController.swift
//  GoodGame
//
//  Created by David Sadler on 11/5/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "savedGameCell"

class FilteredGamesListCollectionViewController: UICollectionViewController {
    
    #warning("Set a background Image for the collection view if the savedGame collection is empty -- kind of like the wow such empty image on reddit app")
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSourceAndDelegation()
        registerCustomCells()
        setupCollectionViewInsets()
    }
    
    // MARK: - Internal Properties
    
    var spacing: CGFloat = 16.0
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var savedGames: [SavedGame]?
    var games: [SavedGame] = []
    var selectedGame: SavedGame? {
        didSet {
            self.performSegue(withIdentifier: "toShowFilteredSavedGame", sender: self)
        }
    }

    // MARK: - Internal Methods
    
    private func setupCollectionViewInsets() {
           let layout = UICollectionViewFlowLayout()
           layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 30)
           layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
           layout.minimumLineSpacing = spacing
           layout.minimumInteritemSpacing = spacing
           self.collectionView?.collectionViewLayout = layout
        }
    
    private func setupDataSourceAndDelegation() {
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
    }
    
    private func registerCustomCells() {
        self.collectionView!.register(UINib(nibName: "SavedGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - UICollectionView DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedGames!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedGameCollectionViewCell else { return UICollectionViewCell() }
        let savedGame = savedGames![indexPath.row]
        cell.coverImageView.image = savedGame.photo
        cell.gameTitleLabel.text = savedGame.title
        return cell
    }

    // MARK: - UICollection ViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedSavedGame = savedGames![indexPath.row]
        selectedGame = selectedSavedGame
    }

    #warning("if game selected show now playing screen")
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowFilteredSavedGame" {
           guard let playStatusVC = segue.destination as? PlayStatusViewController, let selectedGame = selectedGame else { return }
           slideInTransitioningDelegate.direction = .bottom
           playStatusVC.transitioningDelegate = slideInTransitioningDelegate
           playStatusVC.modalPresentationStyle = .custom
           playStatusVC.selectedGame = selectedGame
        }
    }

}

extension FilteredGamesListCollectionViewController: UICollectionViewDelegateFlowLayout {
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
