//
//  NotesTextView+TextFormat.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

extension NotesTextView{
    
    private func changeTrait(trait: UIFontDescriptor.SymbolicTraits) {
        
        let initialFont: UIFont?
        
        if selectedRange.length == 0 {
            initialFont = typingAttributes[NSAttributedString.Key.font] as? UIFont
        } else {
            initialFont = textStorage.attribute(.font, at: selectedRange.location, effectiveRange: nil) as? UIFont
        }
        
        if let currentFont = initialFont{
            
            var currentTraits = currentFont.fontDescriptor.symbolicTraits
            
            // complement the current traits
            let _ = currentTraits.contains(trait) ? currentTraits.remove(trait) : currentTraits.update(with: trait)
            
            if let changedFontDescriptor = currentFont.fontDescriptor.withSymbolicTraits(currentTraits){
                let currentFontSize = currentFont.pointSize
                let updatedFont = UIFont(descriptor: changedFontDescriptor , size: currentFontSize)
                
                if selectedRange.length != 0{
                    textStorage.enumerateAttribute(.font, in: selectedRange, options: .longestEffectiveRangeNotRequired) { (_, range, stop) in
                        textStorage.beginEditing()
                        textStorage.addAttribute(.font, value: updatedFont, range: range)
                        textStorage.endEditing()
                    }
                }
                
                typingAttributes[NSAttributedString.Key.font] = updatedFont
                updateVisualForKeyboard()
            }
        }
    }
    
    @objc func makeTextBold(){
        saveCurrentStateAndRegisterForUndo()
        changeTrait(trait: .traitBold)
    }
    
    @objc func makeTextItalics(){
        saveCurrentStateAndRegisterForUndo()
        changeTrait(trait: .traitItalic)
    }
    
    @objc func makeTextUnderline(){
        
        guard selectedRange.location != NSNotFound else { return }
        
        saveCurrentStateAndRegisterForUndo()
        
        let underlineAttribute: Int?
        
        if selectedRange.length == 0{
            underlineAttribute = typingAttributes[NSAttributedString.Key.underlineStyle] as? Int
        } else {
            underlineAttribute = textStorage.attribute(.underlineStyle, at: selectedRange.location, effectiveRange: nil) as? Int
        }
        
        if let underline = underlineAttribute, underline == NSUnderlineStyle.single.rawValue{
            
            if selectedRange.length != 0{
                textStorage.enumerateAttribute(.underlineStyle, in: selectedRange, options: .longestEffectiveRangeNotRequired) { (_, range, stop) in
                textStorage.beginEditing()
                    textStorage.removeAttribute(NSAttributedString.Key.underlineStyle, range: range)
                    textStorage.endEditing()
                }
            }
            
            typingAttributes.removeValue(forKey: NSAttributedString.Key.underlineStyle)
            
        } else{
            
            if selectedRange.length != 0{
                textStorage.beginEditing()
                textStorage.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
                textStorage.endEditing()
            }
            
            typingAttributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            
        }
        
        updateVisualForKeyboard()
    }
    
    @objc func makeTextStrikethrough(){
        
        guard selectedRange.location != NSNotFound else { return }
        
        saveCurrentStateAndRegisterForUndo()
        
        let strikeThroughAttribute: Int?
        
        if selectedRange.length == 0{
            strikeThroughAttribute = typingAttributes[NSAttributedString.Key.strikethroughStyle] as? Int
        } else {
            strikeThroughAttribute = textStorage.attribute(.strikethroughStyle, at: selectedRange.location, effectiveRange: nil) as? Int
        }
        
        if let strikeThrough = strikeThroughAttribute, strikeThrough == NSUnderlineStyle.single.rawValue{
            
            if selectedRange.length != 0{
                textStorage.enumerateAttribute(.strikethroughStyle, in: selectedRange, options: .longestEffectiveRangeNotRequired) { (_, range, stop) in
                    textStorage.beginEditing()
                    textStorage.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: range)
                    textStorage.endEditing()
                }
            }
            
            typingAttributes.removeValue(forKey: NSAttributedString.Key.strikethroughStyle)
            
        } else{
            
            if selectedRange.length != 0{
                textStorage.beginEditing()
                textStorage.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: selectedRange)
                textStorage.endEditing()
            }
            
            typingAttributes[NSAttributedString.Key.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            
        }
        
        updateVisualForKeyboard()
    }
    
}
