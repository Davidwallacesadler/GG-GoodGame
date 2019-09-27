//
//  GameDetailViewController.swift
//  GoodGame
//
//  Created by David Sadler on 9/26/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    
    // MARK: - View Lifeycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = gameCover {
            gameCoverImageView.image = image
        }
        if let selectedGame = game {
            gameTitleLabel.text = selectedGame.name
        }
    }
    
    // MARK: - Internal Properites
       
       var gameId: Int?
       var gameCover: UIImage? {
        didSet {
            DispatchQueue.main.async {
                self.updateImageView()
            }
        }
    }
    
       var game: Game? {
           didSet {
            GameController.shared.getCoverImageByGameId(gameId!) { (image) in
                guard let coverImage = image else { return }
                self.gameCover = coverImage
               }
           }
       }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    

    func updateImageView() {
        if let gameImage = gameCover {
            self.gameCoverImageView.image = gameImage
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
