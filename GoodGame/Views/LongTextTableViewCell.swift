//
//  LongTextTableViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 11/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class LongTextTableViewCell: UITableViewCell {
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
}
