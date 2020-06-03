//
//  NotesTextView+TextAlignment.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

extension NotesTextView{
    @objc func useLeftAlignment(){
        saveCurrentStateAndRegisterForUndo()
        useAlignment(alignment: .left)
    }
    
    @objc func useCenterAlignment(){
        saveCurrentStateAndRegisterForUndo()
        useAlignment(alignment: .center)
    }
    
    @objc func useRightAlignment(){
        saveCurrentStateAndRegisterForUndo()
        useAlignment(alignment: .right)
    }
    
    private func useAlignment(alignment: NSTextAlignment){
        let coreString = textStorage.string as NSString

        let paraGraphRange = coreString.paragraphRange(for: selectedRange)
        
        let paraString = coreString.substring(with: paraGraphRange)
        guard !paraString.isEmpty else {
            
            if let paraStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
                let modifiedPara = paraStyle.mutableCopy() as! NSMutableParagraphStyle
                modifiedPara.alignment = alignment
                typingAttributes[NSAttributedString.Key.paragraphStyle] = modifiedPara
            } else {
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.alignment = alignment
                typingAttributes[NSAttributedString.Key.paragraphStyle] = paraStyle
            }
            
            updateVisualForKeyboard()
            return
        }
        
        let currentAttributes = textStorage.attributes(at: paraGraphRange.location, effectiveRange: nil)
        
        if let paraStyle = currentAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle{
            // modify the current paragraph style
            let modifiedPara = paraStyle.mutableCopy() as! NSMutableParagraphStyle
            modifiedPara.alignment = alignment
            textStorage.beginEditing()
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: modifiedPara, range: paraGraphRange)
            textStorage.endEditing()
            typingAttributes[NSAttributedString.Key.paragraphStyle] = modifiedPara
        } else {
            // add the paragraph style
            let para = NSMutableParagraphStyle()
            para.alignment = alignment
            textStorage.beginEditing()
            textStorage.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: paraGraphRange)
            textStorage.endEditing()
            typingAttributes[NSAttributedString.Key.paragraphStyle] = para
        }
        
        updateVisualForKeyboard()
    }
}
