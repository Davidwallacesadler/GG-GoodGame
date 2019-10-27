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
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        ViewHelper.roundCornersOf(viewLayer: randomGameButton.layer, withRoundingCoefficient: 10.0)
        ViewHelper.roundCornersOf(viewLayer: reccomendByFilterButton.layer, withRoundingCoefficient: 10.0)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var randomGameButton: UIButton!
    @IBOutlet weak var reccomendByFilterButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
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
            slideInTransitioningDelegate.direction = .bottom
            playStatusVC.transitioningDelegate = slideInTransitioningDelegate
            playStatusVC.modalPresentationStyle = .custom
            playStatusVC.selectedGame = savedGame
        }
    }
    

}
