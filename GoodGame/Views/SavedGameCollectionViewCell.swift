//
//  SavedGameCollectionViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol CollectionViewCellLongTouchDelegate {
    func didLongPress(index: IndexPath)
}

class SavedGameCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    var delegate: CollectionViewCellLongTouchDelegate?
    var indexPath: IndexPath?
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        roundCoverImageViewCorners()
        setupLongPressGesture()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    // MARK: - Internal Methods
    
    private func roundCoverImageViewCorners() {
        ViewHelper.roundCornersOf(viewLayer: coverImageView.layer, withRoundingCoefficient: 3.0)
    }
    
    private func setupLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        addGestureRecognizer(longPressGesture)
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        guard let desiredIndexPath = indexPath else { return }
        if sender.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        if sender.state == .ended {
            delegate?.didLongPress(index: desiredIndexPath)
        }
    }
    
}
