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
        ViewHelper.roundCornersOf(viewLayer: coverImageView.layer, withRoundingCoefficient: 3.0)
    }
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
}
