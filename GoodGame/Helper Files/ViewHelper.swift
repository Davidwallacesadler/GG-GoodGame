//
//  ViewHelper.swift
//  GoodGame
//
//  Created by David Sadler on 10/22/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit

struct ViewHelper {
    static func roundCornersOf(viewLayer: CALayer,withRoundingCoefficient rounding: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = 1.0
        viewLayer.borderColor = UIColor.clear.cgColor
        viewLayer.masksToBounds = true
    }
}
