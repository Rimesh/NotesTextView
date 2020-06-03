//
//  ColorChoiceView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

class ColorChoiceView: UIView{
    
    private let colorView = UIView()
    private let selectionView = UIView()
    
    let tapGesture = UITapGestureRecognizer()
    
    let noSignImageView: UIImageView = {
        let noSignImage = UIImage(systemName: "pencil.slash")
        let imageView = UIImageView(image: noSignImage)
        return imageView
    }()
    
    var isSelected: Bool = false{
        didSet{
            if assignedColor == UIColor.clear{
                selectionView.backgroundColor = .clear
            } else{
                selectionView.backgroundColor = isSelected ? UIColor.tertiaryLabel : .clear
            }
        }
    }
    
    let assignedColor: UIColor
    
    init(frame: CGRect, color: UIColor) {
        assignedColor = color
        super.init(frame: frame)
        
        colorView.backgroundColor = assignedColor
        isSelected = false
        
        addSubview(selectionView)
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        selectionView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        selectionView.heightAnchor.constraint(equalTo: selectionView.widthAnchor, multiplier: 1).isActive = true
        selectionView.centerInSuperview()
        
        addSubview(colorView)
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.widthAnchor.constraint(equalTo: selectionView.widthAnchor, multiplier: 0.80).isActive = true
        colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor, multiplier: 1).isActive = true
        colorView.centerInSuperview()
        
        addGestureRecognizer(tapGesture)
        
        if assignedColor == UIColor.clear{
            selectionView.addSubview(noSignImageView)
            noSignImageView.fillSuperview(padding: .init(top: 3, left: 3, bottom: 3, right: 3))
            noSignImageView.contentMode = .scaleAspectFill
            noSignImageView.tintColor = .systemGray2
            
            noSignImageView.setContentHuggingPriority(UILayoutPriority(0), for: .horizontal)
            noSignImageView.setContentHuggingPriority(UILayoutPriority(0), for: .vertical)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("ColorChoiceView - init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionView.layer.cornerRadius = selectionView.frame.height / 2
        colorView.layer.cornerRadius = colorView.frame.height / 2
    }
}
