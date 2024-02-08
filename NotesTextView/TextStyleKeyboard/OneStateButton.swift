//
//  OneStateButton.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

// This button has only one state.
// It triggers the specified button everytime it is tapped.
// but when user keeps it pressed, it shows highlighted background.
// This button can be used for Changing the Text Indents.

class OneStateButton: UIButton {
    let activeBackgroundColor = #colorLiteral(red: 0.5097514391, green: 0.5098407865, blue: 0.509739697, alpha: 1)
    let inactiveBackgroundColor = UIColor.systemGray6
    let activeTextColor = UIColor.white
    let inactiveTextColor = UIColor.secondaryLabel

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? activeBackgroundColor : inactiveBackgroundColor
            tintColor = isHighlighted ? activeTextColor : inactiveTextColor
        }
    }
}
