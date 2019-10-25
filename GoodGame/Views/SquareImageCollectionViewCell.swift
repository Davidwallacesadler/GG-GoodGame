//
//  SquareImageCollectionViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/20/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SquareImageCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        ViewHelper.roundCornersOf(viewLayer: mainImageView.layer, withRoundingCoefficient: 6.0)
    }
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var mainLabel: UILabel!
}
