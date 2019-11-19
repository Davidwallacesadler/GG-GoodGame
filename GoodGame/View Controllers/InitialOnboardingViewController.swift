//
//  InitialOnboardingViewController.swift
//  GoodGame
//
//  Created by David Sadler on 11/18/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class InitialOnboardingViewController: UIViewController {

    @IBOutlet weak var GetStartedButton: UIButton!
    
    @IBAction func getStartedButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewHelper.roundCornersOf(viewLayer: GetStartedButton.layer, withRoundingCoefficient: Double(GetStartedButton.bounds.height / 3.0))
    }
}
