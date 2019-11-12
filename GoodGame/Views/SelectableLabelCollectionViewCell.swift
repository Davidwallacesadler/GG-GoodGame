//
//  SelectableLabelCollectionViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 11/11/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class SelectableLabelCollectionViewCell: UICollectionViewCell {
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Outlets

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var isSelectedColorView: UIView!
    
}
