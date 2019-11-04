//
//  PlayStatusViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/20/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlayStatusViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    enum images: Int {
        case playIcon = 0
        case pauseIcon = 1
        case favoriteIconSelected = 2
        case favoriteIconUnselected = 3
        case finishIcon = 4
        case finishDeniedIcon = 5
    }
    
    let textView = UITextView(frame: CGRect.zero)
    var selectedGame: SavedGame?
    let playStatusViewImages: [UIImage] = [
        UIImage(named: "playIcon")!,
        UIImage(named: "pauseIcon")!,
        UIImage(named: "favoriteIconSelected")!,
        UIImage(named: "favoriteIconUnselected")!,
        UIImage(named: "finishIcon")!,
        UIImage(named: "finishDeniedIcon")!
    ]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedGame = selectedGame {
            gameTitleLabel.text = savedGame.title
            updateInterfaceBasedOnGameState(game: savedGame)
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteStatusButton: UIButton!
    @IBOutlet weak var finishPlaythroughButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func favoriteStatusButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            SavedGameController.shared.invertFavoriteSatus(savedGame: game)
            updateInterfaceBasedOnGameState(game: game)
        }
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            if game.isBeingCurrentlyPlayed {
                let finishPlaythroughAlert = UIAlertController(title: "How Was Your Playthrough? \n\n\n\n\n", message: nil, preferredStyle: .alert)
                
                let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
                    finishPlaythroughAlert.view.removeObserver(self, forKeyPath: "bounds")
                }
                finishPlaythroughAlert.addAction(cancelAction)

                let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
                    let enteredText = self.textView.text
                    SavedGameController.shared.createPlaythroughHistory(savedGame: game, withComment: enteredText!)
                    SavedGameController.shared.invertPlayingStatus(savedGame: game)
                    finishPlaythroughAlert.view.removeObserver(self, forKeyPath: "bounds")
                }
                finishPlaythroughAlert.addAction(saveAction)
                
                finishPlaythroughAlert.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
                textView.backgroundColor = UIColor.white
                textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
                finishPlaythroughAlert.view.addSubview(self.textView)
                self.present(finishPlaythroughAlert, animated: true, completion: nil)
            } else {
                let notCurrentlyPlayingAlert = UIAlertController(title: "Game Not Being Played", message: "Please hit the play button before attempting to record a playthrough of the game.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                notCurrentlyPlayingAlert.addAction(okayAction)
                self.present(notCurrentlyPlayingAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            if game.isBeingCurrentlyPlayed == false {
                SavedGameController.shared.setBeginningOfPlaythroughDate(forSavedGame: game)
            }
            SavedGameController.shared.invertPlayingStatus(savedGame: game)
            updateInterfaceBasedOnGameState(game: game)
        }
    }
    
    // MARK: - Alert TextView Bounds
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 8
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 54
                let width = rect.width - 2 * margin
                let height: CGFloat = 90

                textView.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
    
    // MARK: - Internal Methods
    
    private func updateInterfaceBasedOnGameState(game: SavedGame) {
        if game.isFavorite {
            let favoriteIconSelectedIndex = images.favoriteIconSelected.rawValue
            favoriteStatusButton.setImage(playStatusViewImages[favoriteIconSelectedIndex], for: .normal)
        } else {
            let favoriteIconUnselectedIndex = images.favoriteIconUnselected.rawValue
            favoriteStatusButton.setImage(playStatusViewImages[favoriteIconUnselectedIndex], for: .normal)
        }
        if game.isBeingCurrentlyPlayed {
            let pauseIconIndex = images.pauseIcon.rawValue
            let finishIconIndex = images.finishIcon.rawValue
            playPauseButton.setImage(playStatusViewImages[pauseIconIndex], for: .normal)
            finishPlaythroughButton.setImage(playStatusViewImages[finishIconIndex], for: .normal)
        } else {
            let playIconIndex = images.playIcon.rawValue
            let finishDeniedIconIndex = images.finishDeniedIcon.rawValue
            playPauseButton.setImage(playStatusViewImages[playIconIndex], for: .normal)
            finishPlaythroughButton.setImage(playStatusViewImages[finishDeniedIconIndex], for: .normal)
        }
    }
}
