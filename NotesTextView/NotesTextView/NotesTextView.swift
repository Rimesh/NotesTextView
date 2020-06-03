//
//  NotesTextView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

public class NotesTextView: UITextView{
    
    enum TextStyle {
        case title
        case heading
        case body
        case serif
    }
    
    let textFieldAnimationDuration: TimeInterval = 0.3
    
    let accessaryView = UIView()
    var keyboardView: UIView? = nil
    
    // Delay timer to switch between keyboards
    var kTimer: Timer?
    
    var isSwitchingKeyboard = false
    
    let styleKeyboard = TextStyleKeyboardView()
    
    let leftIndentButtonMain = UIButton()
    let rightIndentButtonMain = UIButton()
    
    var textFormatBarButtonForiPad: UIBarButtonItem!
    
    let accessoryViewHeight: CGFloat = 50
    let styleKeyboardHeight: CGFloat = 300
    let indentWidth: CGFloat = 20
    let minimumIndent: CGFloat = 0
    let maximumIndent: CGFloat = 200
    
    struct TextState{
        let selectedRange: NSRange
        let attributedText: NSAttributedString
    }
    
    var keyboardHeight: CGFloat = 0.0
    
    override public var selectedTextRange: UITextRange?{
        didSet{
            updateVisualForKeyboard()
        }
    }
    
    public weak var hostingViewController: UIViewController?
    public var shouldAdjustInsetBasedOnKeyboardHeight = false
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        setupTextView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        font = NotesFontProvider.shared.bodyFont
        setupTextView()
    }
    
    override public func becomeFirstResponder() -> Bool {
        
        let isAlreadyFirstResponder = isFirstResponder
        
        let willBecomeFirstResponder = super.becomeFirstResponder()
        
        if !isAlreadyFirstResponder && willBecomeFirstResponder{
            
            if !isSwitchingKeyboard{
                
                var targetLocationForAttributes: Int = 0
                
                if selectedRange.location != NSNotFound && textStorage.length != 0{
                    
                    // selectedRange.Location is actually the length of the string so it becomes out of bounds when the selected range is actually at last character
                    if selectedRange.location == textStorage.length && selectedRange.length == 0{
                        let lastChar = text.suffix(1) as NSString
                        targetLocationForAttributes = max(0, textStorage.length - lastChar.length)
                        
                        // we don't need to update typing attributes here..
                        // it creates a problem if the last character is emoji. (emoji length is variable)
                    } else {
                        targetLocationForAttributes = selectedRange.location
                        typingAttributes = textStorage.attributes(at: targetLocationForAttributes, longestEffectiveRange: nil, in: selectedRange)
                    }
                }
                
                updateVisualForKeyboard()
                
            }
        }
        return willBecomeFirstResponder
    }
    
    override public func resignFirstResponder() -> Bool {
        let willResignFirstResponder = super.resignFirstResponder()
        
        return willResignFirstResponder
    }
    
    override public func paste(_ sender: Any?) {
        
        // Setup code in overridden UITextView.copy/paste
        let pb = UIPasteboard.general
        
        
        // pasting from external source might paste some attributes like images, fonts, colors which are not supported.
        // converting it to plain text to remove all the attributes and give it default font of body.
        
        // UTI List
        let utf8StringType = "public.utf8-plain-text"
        
        pb.items.forEach { (pbDict) in
            if let pastedString = pbDict[utf8StringType] as? String{
                
                // When pasting apply body font attributes
                let attributes: [NSAttributedString.Key : Any] = [
                    NSAttributedString.Key.font : NotesFontProvider.shared.bodyFont,
                    NSAttributedString.Key.foregroundColor : UIColor.label]
                
                let attributed = NSAttributedString(string: pastedString, attributes: attributes)
                
                // how many characters to advance?
                // string counts emojis as single character so don't use string.count
                // convert it to NSString and check its length
                
                let rawString = pastedString as NSString
                
                // Insert pasted string
                self.textStorage.insert(attributed, at:selectedRange.location)
                self.selectedRange.location += rawString.length
                self.selectedRange.length = 0
            }
        }
    }
    
    override public func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        
        
        // after the Title or Heading line,
        // next line should be body font
        
        if text == "\n"{
            if let font = typingAttributes[NSAttributedString.Key.font] as? UIFont{
                if font == NotesFontProvider.shared.headingFont || font == NotesFontProvider.shared.titleFont{
                    typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.bodyFont
                    updateVisualForKeyboard()
                }
            }
            
            if typingAttributes[NSAttributedString.Key.backgroundColor] != nil{
                typingAttributes[NSAttributedString.Key.backgroundColor] = UIColor.clear
            }
        }
        
        return true
    }
    
    func setupTextView(){
        
        typingAttributes[NSAttributedString.Key.font] = NotesFontProvider.shared.bodyFont
        typingAttributes[NSAttributedString.Key.foregroundColor] = UIColor.label
        alwaysBounceVertical = true
        allowsEditingTextAttributes = true
        keyboardDismissMode = .interactive
        
        setupKeyboardActions()
        
        if traitCollection.userInterfaceIdiom == .pad{
            let Aa_IconConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small)
            let textfomratImage = UIImage(systemName: "textformat.size", withConfiguration: Aa_IconConfig)
            textFormatBarButtonForiPad = UIBarButtonItem(image: textfomratImage, style: .plain, target: self, action: #selector(showPopOverKeyboardForiPad))
            
            let buttonGroup = UIBarButtonItemGroup(barButtonItems: [textFormatBarButtonForiPad], representativeItem: nil)
            
            inputAssistantItem.trailingBarButtonGroups = [buttonGroup]
        } else {
            prepareAccessoryView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
        
        styleKeyboard.delegate = self
    }
    
    
    
    @objc private func textDidChange(_ notification: Notification){
        updateVisualForKeyboard()
    }
    
    private func setupKeyboardActions(){
        styleKeyboard.boldButton.addTarget(self, action: #selector(makeTextBold), for: .touchUpInside)
        styleKeyboard.italicButton.addTarget(self, action: #selector(makeTextItalics), for: .touchUpInside)
        styleKeyboard.underlineButton.addTarget(self, action: #selector(makeTextUnderline), for: .touchUpInside)
        styleKeyboard.strikethroughButton.addTarget(self, action: #selector(makeTextStrikethrough), for: .touchUpInside)
        
        styleKeyboard.leftIndentButton.addTarget(self, action: #selector(indentLeft), for: .touchUpInside)
        styleKeyboard.rightIndentButton.addTarget(self, action: #selector(indentRight), for: .touchUpInside)
        
        styleKeyboard.titleButton.tapGesture.addTarget(self, action: #selector(useTitle))
        styleKeyboard.headingButton.tapGesture.addTarget(self, action: #selector(useHeading))
        styleKeyboard.bodyButton.tapGesture.addTarget(self, action: #selector(useBody))
        styleKeyboard.serifButton.tapGesture.addTarget(self, action: #selector(useSerif))
        
        styleKeyboard.returnButton.addTarget(self, action: #selector(showDefaultKeyboard), for: .touchUpInside)
        
        styleKeyboard.leftAlignButton.addTarget(self, action: #selector(useLeftAlignment), for: .touchUpInside)
        styleKeyboard.centerAlignButton.addTarget(self, action: #selector(useCenterAlignment), for: .touchUpInside)
        styleKeyboard.rightAlignButton.addTarget(self, action: #selector(useRightAlignment), for: .touchUpInside)
    }
    
    private func prepareAccessoryView(){
        accessaryView.frame = .init(origin: .zero, size: CGSize(width: 10, height: accessoryViewHeight))
        accessaryView.backgroundColor = .systemGray5
        accessaryView.accessibilityIdentifier = "accessoryView"
        inputAccessoryView = accessaryView
        
        let Aa_IconConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .small)
        let indent_config = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .small)
        
        let textFormatButton = UIButton()
        let textfomratImage = UIImage(systemName: "textformat.size", withConfiguration: Aa_IconConfig)
        textFormatButton.setImage(textfomratImage, for: .normal)
        textFormatButton.addTarget(self, action: #selector(showStyleKeyboard), for: .touchUpInside)
        
        let leftImage = UIImage(systemName: "decrease.indent", withConfiguration: indent_config)
        let rightImage = UIImage(systemName: "increase.indent", withConfiguration: indent_config)
        
        leftIndentButtonMain.setImage(leftImage, for: .normal)
        rightIndentButtonMain.setImage(rightImage, for: .normal)
        
        leftIndentButtonMain.addTarget(self, action: #selector(indentLeft), for: .touchUpInside)
        rightIndentButtonMain.addTarget(self, action: #selector(indentRight), for: .touchUpInside)
        
        leftIndentButtonMain.isEnabled = false
        
        let indentStack = UIStackView(arrangedSubviews: [leftIndentButtonMain, rightIndentButtonMain])
        indentStack.spacing = 20
        
        textFormatButton.tintColor = .systemGray
        leftIndentButtonMain.tintColor = .systemGray
        rightIndentButtonMain.tintColor = .systemGray
        
        accessaryView.addSubview(textFormatButton)
        textFormatButton.anchor(top: accessaryView.topAnchor, leading: accessaryView.safeAreaLayoutGuide.leadingAnchor, bottom: accessaryView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 25, bottom: 0, right: 0))
        
        accessaryView.addSubview(indentStack)
        indentStack.anchor(top: accessaryView.topAnchor, leading: nil, bottom: accessaryView.bottomAnchor, trailing: accessaryView.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20))
    }
    
}
