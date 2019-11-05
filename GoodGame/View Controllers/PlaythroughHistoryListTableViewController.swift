//
//  PlaythroughHistoryListTableViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/27/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlaythroughHistoryListTableViewController: UITableViewController {
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegation()
        registerCustomCells()
    }
    
    // MARK: - Internal Properties
    
    var savedGame: SavedGame?
    var history: [PlaythroughHistory] {
        var playthroughs: [PlaythroughHistory] = []
        guard let selectedGame = savedGame else { return playthroughs }
        for playthrough in selectedGame.playthroughs!.array {
            playthroughs.append(playthrough as! PlaythroughHistory)
        }
        return playthroughs
    }
    
    // MARK: - Internal Methods
    
    private func setupTableViewDelegation() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func registerCustomCells() {
        self.tableView.register(UINib(nibName: "LongTextTableViewCell", bundle: nil), forCellReuseIdentifier: "longTextCell")
    }

    // MARK: - TableView DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "longTextCell", for: indexPath) as? LongTextTableViewCell else { return UITableViewCell() }
        let playthrough = history[indexPath.row]
        let dateBeaten = playthrough.endDate!
        let dateStarted = playthrough.startDate!
        let comment = playthrough.userComment!
        cell.primaryLabel.text = "\(dateStarted.dayMonthYearValue()) to \(dateBeaten.dayMonthYearValue())"
        cell.secondaryLabel.text = comment
        return cell
    }
}
