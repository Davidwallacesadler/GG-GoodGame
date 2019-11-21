//
//  GameGroupingViewController.swift
//  GoodGame
//
//  Created by David Sadler on 11/19/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

private let reuseIdentifier = "savedGameCell"

class GameGroupingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - CollectionView Delegation
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let games = savedGames else { return 0 }
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SavedGameCollectionViewCell, let games = savedGames else { return UICollectionViewCell() }
        let savedGame = games[indexPath.row]
        cell.coverImageView.image = savedGame.photo
        cell.gameTitleLabel.text = savedGame.title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let games = savedGames else { return }
        let selectedGame = games[indexPath.row]
        self.selectedGame = selectedGame
    }
    
    // MARK: - Internal Properties
    
    var savedGames: [SavedGame]?
    var spacing: CGFloat = 16.0
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var selectedGame: SavedGame? {
        didSet {
            self.performSegue(withIdentifier: "toShowFilteredSavedGame", sender: self)
        }
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewDelegation()
        registerCustomCells()
        setupCollectionViewInsets()
        roundButtonCorners()
        updateGamesCountLabel()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var gamesFoundLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var doneButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal Methods
    
    private func setupCollectionViewDelegation() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func registerCustomCells() {
        self.collectionView.register(UINib(nibName: "SavedGameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func setupCollectionViewInsets() {
        let layout = UICollectionViewFlowLayout()
        layout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 30)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.collectionView.collectionViewLayout = layout
    }
    private func roundButtonCorners() {
        ViewHelper.roundCornersOf(viewLayer: doneButton.layer, withRoundingCoefficient: Double(doneButton.bounds.height / 3.0))
    }
    private func updateGamesCountLabel() {
        guard let games = savedGames else { return }
        gamesFoundLabel.text = "\(games.count) Games Found"
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowFilteredSavedGame" {
            guard let playStatusVC = segue.destination as? PlayStatusViewController, let gameToPass = selectedGame else { return }
            slideInTransitioningDelegate.direction = .bottom
            playStatusVC.transitioningDelegate = slideInTransitioningDelegate
            playStatusVC.modalPresentationStyle = .custom
            playStatusVC.selectedGame = gameToPass
        }
    }
}

// MARK: - CollectionViewDelegateFlowLayout

extension GameGroupingViewController: UICollectionViewDelegateFlowLayout {
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
