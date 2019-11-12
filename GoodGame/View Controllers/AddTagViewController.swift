//
//  AddTagViewController.swift
//  GoodGame
//
//  Created by David Sadler on 11/11/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class AddTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection View Delegation
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        return
    }
    
    // MARK: - Properties
    var selectedNameIdPairs: [(String,Int)] = []
    var defaultCollection: [(String,Int)] = []
    var dataSourceCollection: [(String,Int)]?
    var collectionKey: String?
    
    // MARK: - View Lifecycle
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewDelegation()
        registerCollectionViewCells()
    }
    
    // MARK: - Methods
    
    #warning("How could i handle deletion of tags from this view??")
    func getDefaultCollectionFromKey() {
        guard let key = collectionKey else { return }
        switch key {
        case Keys.defaultPlatforms:
            defaultCollection = GamePlatformController.shared.curatedPlatforms.map { (nameIdPair) -> (String,Int) in
                return (nameIdPair.key, nameIdPair.value)
            }
        case Keys.defaultGenres:
            defaultCollection = GameGenreController.shared.possibleGenres.map { (nameIdPair) -> (String,Int) in
                return (nameIdPair.key, nameIdPair.value)
            }
        case Keys.defaultPlayModes:
            defaultCollection = PlayModeController.shared.possiblePlayModes.map({ (nameIdPairs) -> (String,Int) in
                return (nameIdPairs.key, nameIdPairs.value)
            })
        default:
            return
        }
    }
    
    func setupCollectionViewDelegation() {
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
    }
    
    func registerCollectionViewCells() {
        mainCollectionView.register(UINib(nibName: "SelectableLabelCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "labelCell")
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    // MARK: - Actions
    
    @IBAction func addNewTagPressed(_ sender: Any) {
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
