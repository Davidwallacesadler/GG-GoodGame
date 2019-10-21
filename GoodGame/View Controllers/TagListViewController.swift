//
//  TagListViewController.swift
//  GoodGame
//
//  Created by David Sadler on 9/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import WSTagsField

class TagListViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Internal Properties
    
    fileprivate let tagsField = WSTagsField()
    let gameModeNames = ["Single Player", "RPG", "Story Driven", "Arcade", "Beat em' Up", "Brawler", "Fishing", "Driving"]
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           tagsField.beginEditing()
       }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tagsField.frame = tagsView.bounds
        fillTagField()
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tagsView: UIView!
    
    // MARK: - Internal Methods
    
    private func setupTagsView() {
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        tagsField.placeholder = "Enter a tag"
        tagsField.placeholderColor = .white
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tagsField.returnKeyType = .continue
        tagsField.delimiter = ""
        tagsField.textDelegate = self
        tagsField.delegate = self
        textFieldEvents()
    }
    
    private func textFieldEvents() {
        tagsField.onDidAddTag = { field, tag in
            print("DidAddTag", tag.text)
        }

        tagsField.onDidRemoveTag = { field, tag in
            print("DidRemoveTag", tag.text)
        }

        tagsField.onDidChangeText = { _, text in
            print("DidChangeText")
        }

        tagsField.onDidChangeHeightTo = { _, height in
            print("HeightTo", height)
        }

        tagsField.onValidateTag = { tag, tags in
            // custom validations, called before tag is added to tags list
            return tag.text != "#" && !tags.contains(where: { $0.text.uppercased() == tag.text.uppercased() })
        }

        print("List of Tags Strings:", tagsField.tags.map({$0.text}))
    }
    
    private func fillTagField() {
        for gameMode in gameModeNames {
            tagsField.addTag(gameMode)
        }
    }
}

extension TagListViewController: UITextFieldDelegate {
    
}
