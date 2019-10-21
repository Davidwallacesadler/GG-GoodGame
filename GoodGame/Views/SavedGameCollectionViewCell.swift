//
//  SavedGameCollectionViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SavedGameCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        roundCornersOf(viewLayer: coverImageView.layer, withRoundingCoefficient: 3.0)
    }
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    func roundCornersOf(viewLayer: CALayer,withRoundingCoefficient rounding: Double) {
        viewLayer.cornerRadius = CGFloat(rounding)
        viewLayer.borderWidth = 1.0
        viewLayer.borderColor = UIColor.clear.cgColor
        viewLayer.masksToBounds = true
    }
}
