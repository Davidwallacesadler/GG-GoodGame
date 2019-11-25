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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedHistory = history[indexPath.row]
            guard let game = savedGame else { return }
            PlaythroughController.shared.deletePlaythroughFor(savedGame: game, playthrough: selectedHistory)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            guard let playthroughs = game.playthroughs?.array else { return }
            if playthroughs.isEmpty {
                guard let gameDetailDelegate = historyButtonDelegate else { return }
                gameDetailDelegate.updatePlaythroughButton()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(atIndexPath: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    // MARK: - Internal Properties
    var historyButtonDelegate: PlaythroughHistoryDelegate?
    let textView = UITextView(frame: CGRect.zero)
    var selectedHistory: PlaythroughHistory?
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
        addDoneButtonToKeyboard()
        ViewHelper.roundCornersOf(viewLayer: doneButton.layer, withRoundingCoefficient: Double(doneButton.bounds.height / 3.0))
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Internal Methods
    
    private func addDoneButtonToKeyboard() {
       let doneToolBar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0))
       doneToolBar.barStyle = .default
       let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
       let items = [flexSpace,done]
       doneToolBar.items = items
       doneToolBar.sizeToFit()
       textView.inputAccessoryView = doneToolBar
       textView.autocorrectionType = .no
    }
    
    @objc func doneButtonAction() {
        textView.resignFirstResponder()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
           if keyPath == "bounds"{
               if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                   let margin: CGFloat = 8
                   let xPos = rect.origin.x + margin
                   let yPos = rect.origin.y + 54
                   let width = rect.width - 2 * margin
                   let height: CGFloat = 90

                   textView.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
                   textView.text = "Your new comment"
               }
           }
       }
    
    private func displayPlaythroughAlert() {
        if let history = selectedHistory {
            let updateCommentAlert = UIAlertController(title: "Update Your Comment \n\n\n\n\n", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .default) { (action) in
             updateCommentAlert.view.removeObserver(self, forKeyPath: "bounds")
            }
            updateCommentAlert.addAction(cancelAction)
            let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let enteredText = self.textView.text
                PlaythroughController.shared.updatePlaythroughComment(playthrough: history, newComment: enteredText!)
            updateCommentAlert.view.removeObserver(self, forKeyPath: "bounds")
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
                self.tableView.reloadData()
            }
            updateCommentAlert.addAction(saveAction)
            updateCommentAlert.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
            switch self.traitCollection.userInterfaceStyle {
                case .dark:
                    textView.backgroundColor = .darkGray
                    textView.textColor = .white
                default:
                    textView.backgroundColor = .white
                    textView.textColor = .black
            }
            textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
            updateCommentAlert.view.addSubview(self.textView)
            self.present(updateCommentAlert, animated: true, completion: nil)
        }
    }
    
    func editAction(atIndexPath: IndexPath) -> UIContextualAction {
        selectedHistory = history[atIndexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.displayPlaythroughAlert()
            completion(true)
        }
        action.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        return action
       }
    
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
        var minutes = 0
        if differenceInSeconds > amountOfSecondsInADay {
            while differenceInSeconds > amountOfSecondsInADay {
                differenceInSeconds -= amountOfSecondsInADay
                days += 1
            }
        } else if differenceInSeconds > amountOfSecondsInAnHour {
            while differenceInSeconds > amountOfSecondsInAnHour {
                differenceInSeconds -= amountOfSecondsInAnHour
                hours += 1
            }
        } else {
            while differenceInSeconds > 60 {
                differenceInSeconds -= 60
                minutes += 1
            }
        }
        if days == 0 {
            if hours == 0 {
                if minutes == 1 {
                    return "1 Minute"
                } else {
                    return "\(minutes) Minutes"
                }
            } else {
                if hours == 1 {
                    return "1 Hour"
                } else {
                    return "\(hours) Hours"
                }
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
