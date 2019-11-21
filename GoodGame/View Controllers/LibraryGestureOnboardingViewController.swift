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
        tipNumberLabel.text = "Tip 1 of 3"
        ViewHelper.roundCornersOf(viewLayer: gotItButton.layer, withRoundingCoefficient: Double(gotItButton.bounds.height / 3.0 ))
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
            tipNumberLabel.text = "Tip 1 of 3"
        case 1:
            tapIconImageView.image = UIImage(named: "doubleTapIcon")
            mainLabel.text = "To show the play status of a game double tap on the cover image."
            tipNumberLabel.text = "Tip 2 of 3"
        case 2:
            tapIconImageView.image = UIImage(named: "longPressIcon")
            mainLabel.text = "To delete a game from your library, press and hold on the desired cover image."
            tipNumberLabel.text = "Tip 3 of 3"
        default:
            return
        }
    }
    
    @IBOutlet weak var gotItButton: UIButton!
    @IBAction func gotItButtonTapped(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var tapIconImageView: UIImageView!
    @IBOutlet weak var tipNumberLabel: UILabel!
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
