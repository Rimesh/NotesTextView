//
//  ColorPickerView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate: class {
    func didSelectColor(colorPicker: ColorPickerView, selectedColor: UIColor)
}

class ColorPickerView: UIView{
    
    var colorChoices: [UIColor] = []{
        didSet{
            resetChoiceStack()
        }
    }
    
    var selectedColor: UIColor = .label{
        didSet{
            for subview in choiceStack.arrangedSubviews{
                if let choiceView = subview as? ColorChoiceView{
                    choiceView.isSelected = choiceView.assignedColor == selectedColor
                }
            }
        }
    }
    
    weak var delegate: ColorPickerViewDelegate?
    
    private let choiceStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(choiceStack)
        choiceStack.spacing = 2
        choiceStack.distribution = .fillEqually
        
        choiceStack.fillSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalTo: choiceStack.heightAnchor, multiplier: 1).isActive = true
        widthAnchor.constraint(equalTo: choiceStack.widthAnchor, multiplier: 1).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("ColorPickerView - init(coder:) has not been implemented")
    }
    
    private func resetChoiceStack(){
        // empty the choice stack
        for subview in choiceStack.arrangedSubviews{
            subview.removeFromSuperview()
        }
        
        // rebuilt the choice stack
        for choiceColor in colorChoices{
            let choiceView = ColorChoiceView(frame: .zero, color: choiceColor)
            choiceView.tapGesture.addTarget(self, action: #selector(didSelectColor(_:)))
            choiceStack.addArrangedSubview(choiceView)
        }
    }
    
    @objc private func didSelectColor(_ gesture: UITapGestureRecognizer){
        if let tappedChoiceView = gesture.view as? ColorChoiceView{
            for subview in choiceStack.arrangedSubviews{
                if let choiceView = subview as? ColorChoiceView{
                    
                    choiceView.isSelected = tappedChoiceView == choiceView
                    delegate?.didSelectColor(colorPicker: self, selectedColor: tappedChoiceView.assignedColor)
                }
            }
        }
    }
    
}

