//
//  GameLibraryCollectionViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "savedGameCell"

class GameLibraryCollectionViewController: UICollectionViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView?.collectionViewLayout = layout
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "SavedGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    // MARK: - Internal Properties
    
    private let spacing: CGFloat = 16.0
    var savedGames: [SavedGame] {
        get {
            return SavedGameController.shared.savedGames
        }
    }
    var selectedSavedGame: SavedGame?

    // MARK: - UICollectionViewDataSource
    
    #warning("I want sections to be alphebetical")
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return savedGames.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let gameCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedGameCollectionViewCell else { return UICollectionViewCell() }
        let savedGame = savedGames[indexPath.row]
        gameCell.coverImageView.image = savedGame.photo
        gameCell.gameTitleLabel.text = savedGame.title
        return gameCell
    }

    // MARK: - UICollectionViewDelegate
    
    #warning("I want to have a press and hold for the edit screen and a tap to get to the now playing screen")
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let saveGame = savedGames[indexPath.row]
        selectedSavedGame = saveGame
        self.performSegue(withIdentifier: "toShowSavedGame", sender: self)
    }
    

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowSavedGame" {
            guard let detailVC = segue.destination as? GameDetailViewController, let savedGame = selectedSavedGame else { return }
            detailVC.savedGame = savedGame
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
