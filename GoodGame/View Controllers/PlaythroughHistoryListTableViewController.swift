//
//  PlaythroughHistoryListTableViewController.swift
//  GoodGame
//
//  Created by David Sadler on 10/27/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit

class PlaythroughHistoryListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewDelegation()
    }
    
    // MARK: - Internal Properties
    
    var savedGame: SavedGame?
    var history: [PlaythroughHistory] {
        get {
            var playthroughs: [PlaythroughHistory] = []
            guard let selectedGame = savedGame else { return playthroughs }
            for playthrough in selectedGame.playthroughs!.array {
                playthroughs.append(playthrough as! PlaythroughHistory)
            }
            return playthroughs
        }
    }
    
    // MARK: - Internal Methods
    
    private func setupTableViewDelegation() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let playthrough = history[indexPath.row]
        let dateBeaten = playthrough.endDate!
        let dateStarted = playthrough.startDate!
        let comment = playthrough.userComment!
        cell.textLabel?.text = "You started the game on \(dateStarted) and finished it on \(dateBeaten) and here's what you thought: \(comment)"
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
