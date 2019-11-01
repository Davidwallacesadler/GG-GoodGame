//
//  WSTagsFieldHelper.swift
//  GoodGame
//
//  Created by David Sadler on 9/30/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation
import UIKit
import WSTagsField

struct WSTagsFieldHelper {
    
    static func addTagsFieldToView(givenView tagsView: UIView,
                                   tagField tagsField: WSTagsField,
                                   withPlaceholder placeHolder: String) {
        tagsField.frame = tagsView.bounds
        tagsView.addSubview(tagsField)
        tagsField.cornerRadius = 3.0
        tagsField.spaceBetweenLines = 10
        tagsField.spaceBetweenTags = 10
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) //old padding
        tagsField.enableScrolling = true
        tagsField.maxHeight = tagsView.bounds.height
        tagsField.placeholder = placeHolder
        tagsField.placeholderColor = .lightGray
        tagsField.tintColor = .goodGamePinkBright
        tagsField.placeholderAlwaysVisible = true
        tagsField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0)
        tagsField.returnKeyType = .continue
        tagsField.delimiter = ""
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
}
