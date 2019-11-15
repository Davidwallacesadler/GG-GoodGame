//
//  SavedGameCollectionViewCell.swift
//  GoodGame
//
//  Created by David Sadler on 10/14/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

protocol CollectionViewCellLongTouchDelegate {
    func didLongPress(index: IndexPath, sectionKey: String)
}

protocol CollectionViewCellDoublePressDelegate {
    func didDoublePress(index: IndexPath, sectionKey: String)
}

protocol CollectionViewCellSinglePressDelegate {
    func didTap(index: IndexPath, sectionKey: String)
}

class SavedGameCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
             shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
       // Don't recognize a single tap until a double-tap fails.
       if gestureRecognizer == self.singlePressGesture! &&
              otherGestureRecognizer == self.doublePressGesture! {
          return true
       }
       return false
    }
    
    // MARK: - Properties
    var delegate: CollectionViewCellLongTouchDelegate?
    var doublePressDelegate: CollectionViewCellDoublePressDelegate?
    var singlePressDelegate: CollectionViewCellSinglePressDelegate?
    var indexPath: IndexPath?
    var sectionKey: String?

    var doublePressGesture: UIGestureRecognizer?
    var singlePressGesture: UIGestureRecognizer?
    
    // MARK: - View Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        roundCoverImageViewCorners()
        setupLongPressGesture()
        setupDoublePressGesture()
        setupSinglePressGesture()
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
    
    private func setupDoublePressGesture() {
        let doublePressGesture = UITapGestureRecognizer(target: self, action: #selector(doublePress(sender:)))
        doublePressGesture.numberOfTapsRequired = 2
        doublePressGesture.numberOfTouchesRequired = 1
        doublePressGesture.delegate = self
        self.doublePressGesture = doublePressGesture
        addGestureRecognizer(self.doublePressGesture!)
    }
    private func setupSinglePressGesture() {
        let singlePressGesture = UITapGestureRecognizer(target: self, action: #selector(singlePress(sender:)))
        singlePressGesture.numberOfTapsRequired = 1
        singlePressGesture.numberOfTouchesRequired = 1
        singlePressGesture.delegate = self
        self.singlePressGesture = singlePressGesture
        addGestureRecognizer(self.singlePressGesture!)
        singlePressGesture.require(toFail: self.doublePressGesture!)
    }
    
    @objc func singlePress(sender: UITapGestureRecognizer) {
        guard let desiredIndexPath = indexPath, let desiredSection = sectionKey else { return }
        singlePressDelegate?.didTap(index: desiredIndexPath, sectionKey: desiredSection)
    }
    
    @objc func doublePress(sender: UITapGestureRecognizer) {
        guard let desiredIndexPath = indexPath, let desiredSection = sectionKey else { return }
        doublePressDelegate?.didDoublePress(index: desiredIndexPath, sectionKey: desiredSection)
    }
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        guard let desiredIndexPath = indexPath, let desiredSection = sectionKey else { return }
        if sender.state == .began {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
        if sender.state == .ended {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            delegate?.didLongPress(index: desiredIndexPath, sectionKey: desiredSection)
        }
    }
    
}
