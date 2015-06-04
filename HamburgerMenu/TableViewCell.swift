//
//  TableViewCell.swift
//  HamburgerMenu
//
//  Created by Happiest Minds on 27/05/15.
//  Copyright (c) 2015 Coder. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var displayImageView: UIImageView!
    @IBOutlet var imageLeading: NSLayoutConstraint!
    
    let kWidthFactor = 20
    let kXPadding = 8
    let kExtraPadding = 38
    
    var questionGroup: QuestionGroup? {
        didSet {
            if let group = questionGroup {
                let xSpacing = CGFloat(group.level * kWidthFactor) + CGFloat(kXPadding)
                imageLeading.constant = xSpacing
                label.text = "Level \(questionGroup!.level)"
            } else {
                imageLeading.constant = CGFloat(kWidthFactor)
                label.text = ""
            }
        }
    }
}
