//
//  CheckableTableViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class CheckableTableViewCell: UITableViewCell {
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Outlets

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var circleButton: UIImageView!
    
    // MARK: - Methods
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            circleButton.image = UIImage(named: "checkmarkCircleSelected")
        } else {
            circleButton.image = UIImage(named: "checkmarkCircleUnselected")
        }
    }
    
}
