//
//  CheckableTableViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class CheckableTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var circleButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            circleButton.setImage(UIImage(named: "checkmarkCircleSelected")!, for: .normal)
        } else {
            circleButton.setImage(UIImage(named: "checkmarkCircleUnselected")!, for: .normal)
        }
    }
    
}
