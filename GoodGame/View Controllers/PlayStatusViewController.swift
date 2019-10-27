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
    
    var selectedGame: SavedGame?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedGame = selectedGame {
            gameTitleLabel.text = savedGame.title
            if savedGame.isBeingCurrentlyPlayed {
                playPauseButton.setImage(#imageLiteral(resourceName: "PauseImage"), for: .normal)
                finishPlaythroughButton.setImage(#imageLiteral(resourceName: "FinishIcon"), for: .normal)
            }
            if savedGame.isFavorite {
                favoriteStatusButton.setImage(#imageLiteral(resourceName: "favoriteIconSelected"), for: .normal)
            }
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
            if game.isFavorite {
                favoriteStatusButton.setImage(#imageLiteral(resourceName: "favoriteIconUnselected"), for: .normal)
            } else {
                favoriteStatusButton.setImage(#imageLiteral(resourceName: "favoriteIconSelected"), for: .normal)
            }
            SavedGameController.shared.invertFavoriteSatus(savedGame: game)
        }
    }
    @IBAction func finishButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            if game.isBeingCurrentlyPlayed {
                let finishPlaythroughAlert = UIAlertController(title: "How Was Your Playthrough?", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                finishPlaythroughAlert.addAction(cancelAction)
                self.present(finishPlaythroughAlert, animated: true, completion: nil)
                // HAVE THIS BE THE HANDLER
                SavedGameController.shared.createPlaythroughHistory(savedGame: game, withComment: "I had a great time beating this game again!")
                SavedGameController.shared.invertPlayingStatus(savedGame: game)
                
            } else {
                let notCurrentlyPlayingAlert = UIAlertController(title: "Game Not Being Played", message: "Please hit the play button before attempting to finish the game.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                notCurrentlyPlayingAlert.addAction(okayAction)
                self.present(notCurrentlyPlayingAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            if game.isBeingCurrentlyPlayed {
                finishPlaythroughButton.setImage(#imageLiteral(resourceName: "finishDeniedIcon"), for: .normal)
                playPauseButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
            } else {
                finishPlaythroughButton.setImage(#imageLiteral(resourceName: "FinishIcon"), for: .normal)
                playPauseButton.setImage(#imageLiteral(resourceName: "PauseImage"), for: .normal)
                SavedGameController.shared.setBeginningOfPlaythroughDate(forSavedGame: game)
            }
            SavedGameController.shared.invertPlayingStatus(savedGame: game)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
