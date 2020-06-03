//
//  NotesTextView+Indents.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

extension NotesTextView{
    
    func getCurrentIndent() -> CGFloat{
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        let paraString = coreString.substring(with: paraGraphRange)
        guard !paraString.isEmpty else {
            if let paraStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
                return paraStyle.headIndent
            } else {
                return minimumIndent
            }
        }
        
        let currentAttributes = textStorage.attributes(at: paraGraphRange.location, effectiveRange: nil)
        
        if let paraStyle = currentAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
            return paraStyle.headIndent
        } else {
            return minimumIndent
        }
    }
    
    @objc func indentLeft(){
        
        saveCurrentStateAndRegisterForUndo()
        
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        let paraString = coreString.substring(with: paraGraphRange)
        guard !paraString.isEmpty else {
            if let paraStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
                let modifiedPara = paraStyle.mutableCopy() as! NSMutableParagraphStyle
                modifiedPara.headIndent = max(minimumIndent, modifiedPara.firstLineHeadIndent-indentWidth)
                modifiedPara.firstLineHeadIndent = modifiedPara.headIndent
                typingAttributes[NSAttributedString.Key.paragraphStyle] = modifiedPara
            } else {
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.headIndent = indentWidth
                paraStyle.firstLineHeadIndent = indentWidth
                typingAttributes[NSAttributedString.Key.paragraphStyle] = paraStyle
            }
            
            updateVisualForKeyboard()
            return
        }
        
        let currentAttributes = textStorage.attributes(at: paraGraphRange.location, effectiveRange: nil)
        
        if let paraStyle = currentAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
            // modify the current paragraph style
            let modifiedPara = paraStyle.mutableCopy() as! NSMutableParagraphStyle
            modifiedPara.headIndent = max(minimumIndent, modifiedPara.firstLineHeadIndent-indentWidth)
            modifiedPara.firstLineHeadIndent = modifiedPara.headIndent
            textStorage.beginEditing()
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: modifiedPara, range: paraGraphRange)
            textStorage.endEditing()
        } else {
            // add the paragraph style
            let para = NSMutableParagraphStyle()
            para.firstLineHeadIndent = 0
            para.headIndent = 0
            textStorage.beginEditing()
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: paraGraphRange)
            textStorage.endEditing()
        }
        
        updateVisualForKeyboard()
    }
    
    @objc func indentRight(){
        
        saveCurrentStateAndRegisterForUndo()
        
        let coreString = textStorage.string as NSString
        
        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        let paraString = coreString.substring(with: paraGraphRange)
        guard !paraString.isEmpty else {
            
            if let paraStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
                let modifiedPara = paraStyle.mutableCopy() as! NSMutableParagraphStyle
                modifiedPara.headIndent = min(modifiedPara.headIndent + indentWidth, maximumIndent)
                modifiedPara.firstLineHeadIndent = modifiedPara.headIndent
                typingAttributes[NSAttributedString.Key.paragraphStyle] = modifiedPara
            } else {
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.headIndent = indentWidth
                paraStyle.firstLineHeadIndent = indentWidth
                typingAttributes[NSAttributedString.Key.paragraphStyle] = paraStyle
            }
            
            updateVisualForKeyboard()
            return
        }
        
        let currentAttributes = textStorage.attributes(at: paraGraphRange.location, effectiveRange: nil)
        
        if let paraStyle = currentAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
            // modify the current paragraph style
            let modifiedPara = paraStyle.mutableCopy() as! NSMutableParagraphStyle
            modifiedPara.headIndent = min(modifiedPara.headIndent + indentWidth, maximumIndent)
            modifiedPara.firstLineHeadIndent = modifiedPara.headIndent
            textStorage.beginEditing()
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: modifiedPara, range: paraGraphRange)
            textStorage.endEditing()
        } else {
            // add the paragraph style
            let para = NSMutableParagraphStyle()
            para.firstLineHeadIndent = indentWidth
            para.headIndent = indentWidth
            textStorage.beginEditing()
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: paraGraphRange)
            textStorage.endEditing()
        }
        
        updateVisualForKeyboard()
    }
    
}
