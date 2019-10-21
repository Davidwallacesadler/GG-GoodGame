//
//  ReccomendsFilterViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/20/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class ReccomendsFilterViewController: UIViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Outlets
    @IBOutlet weak var platformsTableView: UITableView!
    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var gameModesTableView: UITableView!
    
    // MARK: - Actions
    @IBAction func filterButtonPressed(_ sender: Any) {
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
