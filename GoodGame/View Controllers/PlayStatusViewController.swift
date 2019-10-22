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
            gameCoverImageView.image = savedGame.photo
            gameTitleLabel.text = savedGame.title
            print("game is being Played: \(savedGame.isBeingCurrentlyPlayed)")
            print("is game favorite: \(savedGame.isFavorite)")
        }
        
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var favoriteStatusButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func favoriteStatusButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            SavedGameController.shared.invertFavoriteSatus(savedGame: game)
            print("is game favorite \(game.isFavorite)")
        }
    }
    @IBAction func finishButtonPressed(_ sender: Any) {
        #warning("maybe pop up a rating and comment view where the iser can leave a rating and a comment for their playthrough -- maybe this creates a history of playthroughs for the saved game.")
    }
    
    @IBAction func playPauseButtonPressed(_ sender: Any) {
        if let game = selectedGame {
            SavedGameController.shared.invertPlayingStatus(savedGame: game)
            print("game is being Played: \(game.isBeingCurrentlyPlayed)")
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
