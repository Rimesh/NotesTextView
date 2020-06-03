//
//  NotesTextView+KeyboardManagement.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

extension NotesTextView{
    
    @objc func keyboardWillShow(notification: NSNotification){
         
         if let userInfo = notification.userInfo, let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             
             keyboardHeight = keyboardSize.height
            
            if !isSwitchingKeyboard && shouldAdjustInsetBasedOnKeyboardHeight {
                contentInset = .init(top: 12, left: 0, bottom: keyboardHeight, right: 0)
            }
            
            
         } else {
            // no userInfo dictionary in notification
         }
         
     }
     
     @objc func keyboardWillHide(notification: NSNotification){
         keyboardHeight = 0
         if !isSwitchingKeyboard && shouldAdjustInsetBasedOnKeyboardHeight {
             contentInset = .init(top: 12, left: 0, bottom: 0, right: 0)
         }
     }
    
    @objc func showDefaultKeyboard(){
        
        inputView = nil
        inputAccessoryView = accessaryView
        isSwitchingKeyboard = true
        let _ = resignFirstResponder()
        kTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.keyboardView?.removeFromSuperview()
            self.keyboardView = nil
            let _ = self.becomeFirstResponder()
            self.kTimer = nil
            self.isSwitchingKeyboard = false
        })
        
        updateVisualForKeyboard()
    }
    
    @objc func showStyleKeyboard(){
        
        let bottomSafeAreaInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0.0
        
        let keyboardView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: frame.width, height: styleKeyboardHeight + bottomSafeAreaInset)))
        keyboardView.backgroundColor = .tertiarySystemBackground
        keyboardView.accessibilityIdentifier = "keyboardviewCustom"
        
        keyboardView.addSubview(styleKeyboard)
        styleKeyboard.translatesAutoresizingMaskIntoConstraints = false
        styleKeyboard.fillSuperview()
        
        keyboardView.layoutIfNeeded()
        self.keyboardView = keyboardView
        inputAccessoryView = nil
        inputView = keyboardView
        
        isSwitchingKeyboard = true
        let _ = resignFirstResponder()
        
        kTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let _ = self.becomeFirstResponder()
            self.kTimer = nil
            self.isSwitchingKeyboard = false
        })
        
        
        updateVisualForKeyboard()
    }

    @objc func showPopOverKeyboardForiPad(){
        
        let popOverKeyboardVC = UIViewController(nibName: nil, bundle: nil)
        popOverKeyboardVC.view.frame = .init(origin: .zero, size: .init(width: 370, height: styleKeyboardHeight))
        
        popOverKeyboardVC.view.backgroundColor = .tertiarySystemBackground
        popOverKeyboardVC.modalPresentationStyle = .popover
        
        popOverKeyboardVC.view.addSubview(styleKeyboard)
        styleKeyboard.fillSuperview()
        
        popOverKeyboardVC.view.layoutIfNeeded()
        styleKeyboard.returnButton.isHidden = true
        
        popOverKeyboardVC.popoverPresentationController?.barButtonItem = textFormatBarButtonForiPad
        popOverKeyboardVC.preferredContentSize = CGSize(width: 370, height: styleKeyboardHeight)
        
        hostingViewController?.present(popOverKeyboardVC, animated: true, completion: nil)

    }
    
    // MARK:- Update Keyboard Visuals
    
    func updateVisualForKeyboard(){
        
        var isBold = false
        var isItalics = false
        var hasUnderline = false
        var hasStrikethrough = false
        var currentTextStyle: NotesTextView.TextStyle = .body
        var shouldLeftIndentDisabled: Bool = false
        var shouldRightIndentDisabled: Bool = false
        
        let currentFont: UIFont?
        let currentParaStyle: NSParagraphStyle?
        
        if selectedRange.length == 0{
            currentFont = typingAttributes[NSAttributedString.Key.font] as? UIFont
            currentParaStyle = typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle
        } else{
            currentFont = textStorage.attribute(.font, at: selectedRange.location, effectiveRange: nil) as? UIFont
            currentParaStyle = textStorage.attribute(.paragraphStyle, at: selectedRange.location, effectiveRange: nil) as? NSParagraphStyle
        }
        
        if let font = currentFont{
            
            isBold = font.fontDescriptor.symbolicTraits.contains(UIFontDescriptor.SymbolicTraits.traitBold)
            isItalics = font.fontDescriptor.symbolicTraits.contains(UIFontDescriptor.SymbolicTraits.traitItalic)
            
            // No matter what I do, I am unable to idenitify current font because of Bold and Italics properties being applied.
            
            // I have tried adding bold and italics to serif font and then compare with current font but no success
            
            // I even tried removing bold and italics from current font and then compare with Serif but no success.
            
            // if we use withDesign(.serif) to get the serif font then we can not identify the current font is serif when bold and Italics are applied
            // but if use the font by name like "Georgia" to get serif font then we can identify the current font is serif even when bold and Italics are applied.
            // this problem arises when attributed text is retrieved back from CoreData
            
            let checkFont = font.withBoldWithoutItalics()
            
            if checkFont == NotesFontProvider.shared.serifFont.withBoldWithoutItalics(){
                currentTextStyle = .serif
            } else if checkFont == NotesFontProvider.shared.titleFont.withBoldWithoutItalics(){
                currentTextStyle = .title
            } else if checkFont == NotesFontProvider.shared.headingFont.withBoldWithoutItalics(){
                currentTextStyle = .heading
            } else if checkFont == NotesFontProvider.shared.bodyFont.withBoldWithoutItalics(){
                currentTextStyle = .body
            }
        }
        
        let currentIndent = getCurrentIndent()
        
        shouldLeftIndentDisabled = currentIndent == minimumIndent
        shouldRightIndentDisabled = currentIndent == maximumIndent
        
        var currentAlignment: NSTextAlignment = .left
        
        if let paragraphStyle = currentParaStyle{
            switch paragraphStyle.alignment {
            case .left:     currentAlignment = .left
            case .center:   currentAlignment = .center
            case .right:    currentAlignment = .right
            default:
                currentAlignment = .left
            }
        }
        
        hasUnderline = typingAttributes[NSAttributedString.Key.underlineStyle] as? Int == NSUnderlineStyle.single.rawValue
        hasStrikethrough = typingAttributes[NSAttributedString.Key.strikethroughStyle] as? Int == NSUnderlineStyle.single.rawValue
        
        let selectedTextColor = typingAttributes[.foregroundColor] as? UIColor
        let selectedHighlightColor = typingAttributes[.backgroundColor] as? UIColor ?? UIColor.clear
        
        styleKeyboard.typingAttributeUpdates(currentTextStyle: currentTextStyle, isBold: isBold, isItalics: isItalics, isUnderline: hasUnderline, hasStrikethrough: hasStrikethrough, disableLeftIndent: shouldLeftIndentDisabled, disableRightIndent: shouldRightIndentDisabled, textColor: selectedTextColor, highlighColor: selectedHighlightColor, textAlignment: currentAlignment)
        
        leftIndentButtonMain.isEnabled = !shouldLeftIndentDisabled
        rightIndentButtonMain.isEnabled = !shouldRightIndentDisabled
    }
}
