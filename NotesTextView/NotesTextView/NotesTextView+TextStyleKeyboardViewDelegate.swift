//
//  NotesTextView+TextStyleKeyboardViewDelegate.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

extension NotesTextView: TextStyleKeyboardViewDelegate{
    func didSelectTextColor(selectedColor: UIColor) {

        
        guard selectedRange.location != NSNotFound else { return }
        
        saveCurrentStateAndRegisterForUndo()
        
        textStorage.enumerateAttribute(.foregroundColor, in: selectedRange, options: .longestEffectiveRangeNotRequired) { (_, range, stop) in
            textStorage.beginEditing()
            textStorage.addAttribute(.foregroundColor, value: selectedColor, range: range)
            textStorage.endEditing()
        }
        
        typingAttributes[.foregroundColor] = selectedColor
        updateVisualForKeyboard()
    }
    
    func didSelectHighlightColor(selectedColor: UIColor) {
        
        guard selectedRange.location != NSNotFound else { return }
        
        saveCurrentStateAndRegisterForUndo()
        
        if selectedColor == UIColor.clear{
            // we need to remove the background color
            
            if selectedRange.length != 0{
                textStorage.enumerateAttribute(.backgroundColor, in: selectedRange, options: .longestEffectiveRangeNotRequired) { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.removeAttribute(.backgroundColor, range: range)
                    textStorage.endEditing()
                }
            }
            
            typingAttributes[.backgroundColor] = selectedColor
            updateVisualForKeyboard()
        } else {
            // we need to add the background color
            
            if selectedRange.length != 0{
                textStorage.enumerateAttribute(.backgroundColor, in: selectedRange, options: .longestEffectiveRangeNotRequired) { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.addAttribute(.backgroundColor, value: selectedColor as Any, range: range)
                    textStorage.endEditing()
                }
            }
            
            typingAttributes[.backgroundColor] = selectedColor
            updateVisualForKeyboard()
        }
        
        
    }
}
