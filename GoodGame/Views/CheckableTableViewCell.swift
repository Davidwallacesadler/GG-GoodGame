//
//  CheckableTableViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/25/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class CheckableTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var cellIsSelected: Bool = false {
        didSet {
            
        }
    }
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Outlets

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var circleButton: UIImageView!
    
    // MARK: - Methods
    
    func updateSelectedStatus() {
        cellIsSelected = !cellIsSelected
        
    }
    
    func updateCheckmarkImage() {
        switch cellIsSelected {
        case true:
            circleButton.image = UIImage(named: "checkmarkCircleSelected")
        default:
            circleButton.image = UIImage(named: "checkmarkCircleUnselected")
        }
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selected {
//            circleButton.image = UIImage(named: "checkmarkCircleSelected")
//        } else {
//            circleButton.image = UIImage(named: "checkmarkCircleUnselected")
//        }
//    }
    
}
