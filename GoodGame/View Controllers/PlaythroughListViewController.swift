//
//  PlaythroughListViewController.swift
//  GoodGame
//
//  Created by David Sadler on 11/19/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlaythroughListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView Delegation
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "longTextCell", for: indexPath) as? LongTextTableViewCell else { return UITableViewCell() }
        let playthrough = history[indexPath.row]
        let playthroughNumber = "Playthrough #\(history.count - indexPath.row): "
        cell.secondaryLabel.text = playthroughNumber
        let dateBeaten = playthrough.endDate!
        let dateStarted = playthrough.startDate!
        let timeToBeat = timeBetweenTwoDates(dateOne: dateBeaten, dateTwo: dateStarted)
        if let userComment = playthrough.userComment {
            cell.secondaryLabel.text! += userComment
        }
        if dateStarted.dayMonthYearValue() == dateBeaten.dayMonthYearValue() {
            cell.primaryLabel.text = "\(dateStarted.dayMonthYearValue()) (\(timeToBeat))"
        } else {
            cell.primaryLabel.text = "\(dateStarted.dayMonthYearValue()) to \(dateBeaten.dayMonthYearValue()) (\(timeToBeat))"
        }
        return cell
    }
    
    // MARK: - Internal Properties
    
    var savedGame: SavedGame?
    var history: [PlaythroughHistory] {
        var playthroughs: [PlaythroughHistory] = []
        guard let selectedGame = savedGame else { return playthroughs }
        for playthrough in selectedGame.playthroughs!.array {
            playthroughs.append(playthrough as! PlaythroughHistory)
        }
        playthroughs.sort { (playthoughHistoryOne, playthoughHistoryTwo) -> Bool in
            return playthoughHistoryOne.endDate! > playthoughHistoryTwo.endDate!
        }
        return playthroughs
    }
    
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegation()
        registerCustomCells()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal Methods
    
    private func setupTableViewDelegation() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func registerCustomCells() {
        self.tableView.register(UINib(nibName: "LongTextTableViewCell", bundle: nil), forCellReuseIdentifier: "longTextCell")
    }
    
    private func timeBetweenTwoDates(dateOne: Date, dateTwo: Date) -> String {
        let dateOneInterval = dateOne.timeIntervalSince1970
        let dateTwoInterval = dateTwo.timeIntervalSince1970
        let amountOfSecondsInAnHour = 3600.0
        let amountOfSecondsInADay = amountOfSecondsInAnHour * 24.0
        var differenceInSeconds = (dateOneInterval - dateTwoInterval).magnitude
        var days = 0
        var hours = 0
        if differenceInSeconds > amountOfSecondsInADay {
            while differenceInSeconds > amountOfSecondsInADay {
                differenceInSeconds -= amountOfSecondsInADay
                days += 1
            }
        } else {
            while differenceInSeconds > amountOfSecondsInAnHour {
                differenceInSeconds -= amountOfSecondsInAnHour
                hours += 1
            }
        }
        if days == 0 {
            if hours == 1 {
                return "1 Hour"
            } else {
                return "\(hours) Hours"
            }
        } else {
            if days == 1 {
                return "1 Day"
            } else {
                return "\(days) Days"
            }
        }
    }

}
