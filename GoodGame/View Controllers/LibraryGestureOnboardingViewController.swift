//
//  LibraryGestureOnboardingViewController.swift
//  GoodGame
//
//  Created by David Sadler on 11/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class LibraryGestureOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tapIconImageView.image = UIImage(named: "tapIcon")
        mainLabel.text = "To edit your game or view your playthrough history simply tap the cover image."
    }
    var viewHasBeenTappedTimes: Int = 0 {
        didSet {
            updateTip()
        }
    }
    func updateTip() {
        switch viewHasBeenTappedTimes {
        case 0:
            tapIconImageView.image = UIImage(named: "tapIcon")
            mainLabel.text = "To edit your game or view your playthrough history simply tap the cover image."
        case 1:
            tapIconImageView.image = UIImage(named: "doubleTapIcon")
            mainLabel.text = "To show the play status of a game double tap on the cover image."
        case 2:
            tapIconImageView.image = UIImage(named: "longPressIcon")
            mainLabel.text = "To delete a game from your library, press and hold on the desired cover image."
        default:
            return
        }
    }
    
    @IBOutlet weak var tapIconImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBAction func viewTapped(_ sender: Any) {
        if viewHasBeenTappedTimes < 2 {
            viewHasBeenTappedTimes += 1
        } else {
            viewHasBeenTappedTimes = 0
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
