//
//  TextStyleView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

class TextStyleView: UIView {
    let label = UILabel()

    let activeBackgroundColor = #colorLiteral(red: 0.5097514391, green: 0.5098407865, blue: 0.509739697, alpha: 1)
    let inactiveBackgroundColor = UIColor.clear
    let activeTextColor = UIColor.white
    let inactiveTextColor = UIColor.secondaryLabel

    let tapGesture = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(label)
        label.textAlignment = .center
        label.centerInSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: label.widthAnchor, multiplier: 1, constant: 22).isActive = true
        addGestureRecognizer(tapGesture)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("StyleView: init(coder:) has not been implemented")
    }

    var isActive = false {
        didSet {
            backgroundColor = isActive ? activeBackgroundColor : inactiveBackgroundColor
            label.textColor = isActive ? activeTextColor : inactiveTextColor
        }
    }
}
