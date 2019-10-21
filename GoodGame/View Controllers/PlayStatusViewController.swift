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
        }
        
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameCoverImageView: UIImageView!
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
