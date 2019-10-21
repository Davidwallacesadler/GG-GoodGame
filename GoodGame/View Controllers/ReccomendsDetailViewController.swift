//
//  ReccomendsDetailViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/20/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class ReccomendsDetailViewController: UIViewController {
    
    // MARK: - Internal Properties
    var selectedGame: SavedGame?
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func randomGameButtonPressed(_ sender: Any) {
        getRandomGame()
    }
    
    private func getRandomGame() {
        guard let randomGame = SavedGameController.shared.savedGames.randomElement() else { return }
        selectedGame = randomGame
        self.performSegue(withIdentifier: "toShowGamePlayStatus", sender: self)
    }
    
    #warning("want to segue to the now playing VC with the random game")

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toShowGamePlayStatus" {
            guard let playStatusVC = segue.destination as? PlayStatusViewController, let savedGame = selectedGame else { return }
            playStatusVC.selectedGame = savedGame
        }
    }
    

}
