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
    var randomButtonFlipped = false
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        roundCornersOfButtons()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var randomGameButton: UIButton!
    @IBOutlet weak var reccomendByFilterButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func randomGameButtonPressed(_ sender: Any) {
        if randomButtonFlipped {
            self.performSegue(withIdentifier: "toShowGamePlayStatus", sender: self)
        } else {
           getRandomGameAndFlipCard()
        }
    }
    
    // MARK: - Internal Methods
    
    @objc func flipCardAgain(_ sender: UITapGestureRecognizer) {
        getRandomGameAndFlipCard()
    }
    
    private func getRandomGameAndFlipCard() {
        randomButtonFlipped = true
        guard let randomGame = SavedGameController.shared.savedGames.randomElement() else { return }
        selectedGame = randomGame
        let randomGameImage = randomGame.photo
        randomGameButton.setBackgroundImage(randomGameImage, for: .normal)
        let backArrowIconView = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 50.0))
        let backArrowIconImage = UIImage(named: "backArrowIcon")
        let backArrowIconImageView = UIImageView(image: backArrowIconImage)
        backArrowIconImageView.frame = backArrowIconView.frame
        backArrowIconImageView.tintColor = .goodGamePinkBright
        backArrowIconView.addSubview(backArrowIconImageView)
        randomGameButton.addSubview(backArrowIconView)
        let flipBackGesture = UITapGestureRecognizer(target: self, action: #selector(flipCardAgain(_:)))
        backArrowIconView.addGestureRecognizer(flipBackGesture)
        randomGameButton.setImage(UIImage(), for: .normal)
        randomGameButton.setTitle("\(randomGame.title!)", for: .normal)
        UIView.transition(with: randomGameButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    private func roundCornersOfButtons() {
        ViewHelper.roundCornersOf(viewLayer: randomGameButton.layer, withRoundingCoefficient: 10.0)
        ViewHelper.roundCornersOf(viewLayer: reccomendByFilterButton.layer, withRoundingCoefficient: 10.0)
    }
    
    private func getRandomGame() {
        guard let randomGame = SavedGameController.shared.savedGames.randomElement() else { return }
        selectedGame = randomGame
        self.performSegue(withIdentifier: "toShowGamePlayStatus", sender: self)
    }
    
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
