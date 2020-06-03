//
//  TextStyleKeyboardView.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

protocol TextStyleKeyboardViewDelegate: class{
    func didSelectTextColor(selectedColor: UIColor)
    func didSelectHighlightColor(selectedColor: UIColor)
}

class TextStyleKeyboardView: UIView{
    
    // MARK:- Text Formatting Buttons
    let boldButton = TwoStateButton()
    let italicButton = TwoStateButton()
    let underlineButton = TwoStateButton()
    let strikethroughButton = TwoStateButton()
    
    //MARK:- Text Alignment Buttons
    let leftAlignButton = TwoStateButton()
    let centerAlignButton = TwoStateButton()
    let rightAlignButton = TwoStateButton()
    
    // MARK:- Text Indent Buttons
    let leftIndentButton = OneStateButton()
    let rightIndentButton = OneStateButton()
    
    // MARK:- Text Style View
    let titleButton = TextStyleView()
    let headingButton = TextStyleView()
    let bodyButton = TextStyleView()
    let serifButton = TextStyleView()
    let styleScrollView = UIScrollView()
    let gradientMask = CAGradientLayer()
    let scrollContainerView = UIView()
    
    let keyboardContainerView = UIView()
    
    // MARK:- Color Maps
    let textColorMap: [TransformedColor] = [
        TransformedColor(visualColor: UIColor.label, appliedColor: UIColor.label),
        TransformedColor(visualColor: UIColor.systemRed, appliedColor: UIColor.FETextRed),
        TransformedColor(visualColor: UIColor.systemOrange, appliedColor: UIColor.FETextOrange),
        TransformedColor(visualColor: UIColor.systemGreen, appliedColor: UIColor.FETextGreen),
        TransformedColor(visualColor: UIColor.systemBlue, appliedColor: UIColor.FETextBlue)
    ]
    
    let highlightColorMap: [TransformedColor] = [
        TransformedColor(visualColor: UIColor.clear, appliedColor: UIColor.clear),
        TransformedColor(visualColor: UIColor.systemRed, appliedColor: UIColor.FEHighlightRed),
        TransformedColor(visualColor: UIColor.systemOrange, appliedColor: UIColor.FEHighlightOrange),
        TransformedColor(visualColor: UIColor.systemGreen, appliedColor: UIColor.FEHighlightGreen),
        TransformedColor(visualColor: UIColor.systemBlue, appliedColor: UIColor.FEHighlightBlue)
    ]
    
    // MARK:- Color Picker Views
    lazy var textColors = textColorMap.map({$0.visualColor})
    lazy var highLightColors = highlightColorMap.map({$0.visualColor})
    let textColorPicker = ColorPickerView()
    let highlightColorPicker = ColorPickerView()
    
    // MARK:- Color Segmented Control
    let colorSegmentControl = UISegmentedControl(items: ["fontColor", "hightlightColor"])

    // MARK:- Return Button
    let returnButton = UIButton()
    
    // MARK:- Spacing Contants
    let buttonSpacing: CGFloat = 3
    let buttonWidth: CGFloat = 61
    let buttonHeight: CGFloat = 50
    let buttonCornerRadius : CGFloat = 10
    let styleScrollInset: CGFloat = 12
    
    // MARK:- Layout stacks
    let formatingStack = UIStackView()
    let indentStack = UIStackView()
    let textStyleStack = UIStackView()
    let textAlignmentStack = UIStackView()
    let colorStack = UIStackView()
    private let completeStack = UIStackView()
    
    // MARK:- SFSymbol Config
    let iconConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular, scale: .medium)
    
    weak var delegate: TextStyleKeyboardViewDelegate?
    
    // MARK:- Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyleKeyboard()
        
        addSubview(keyboardContainerView)
        keyboardContainerView.fillSuperview()
        
        keyboardContainerView.addSubview(scrollContainerView)
        scrollContainerView.addSubview(styleScrollView)
        styleScrollView.fillSuperview()
        
        keyboardContainerView.addSubview(completeStack)
        
        scrollContainerView.anchor(top: keyboardContainerView.topAnchor, leading: completeStack.leadingAnchor, bottom: nil, trailing: completeStack.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 60))
        
        styleScrollView.contentInset = .init(top: 0, left: styleScrollInset, bottom: 0, right: styleScrollInset)
        scrollContainerView.constrainHeight(constant: buttonHeight)
        
        completeStack.anchor(top: scrollContainerView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        completeStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 8).isActive = true
        
        setupReturnButton()
        
        textColorPicker.delegate = self
        highlightColorPicker.delegate = self
        
        backgroundColor = .tertiarySystemBackground
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("TextStyleKeyboardView - init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientMask.frame = scrollContainerView.bounds
    }
    
    func typingAttributeUpdates(currentTextStyle: NotesTextView.TextStyle, isBold: Bool, isItalics: Bool, isUnderline: Bool, hasStrikethrough: Bool, disableLeftIndent: Bool, disableRightIndent: Bool, textColor: UIColor?, highlighColor: UIColor?, textAlignment: NSTextAlignment) {
        
        titleButton.isActive = currentTextStyle == .title
        headingButton.isActive = currentTextStyle == .heading
        bodyButton.isActive = currentTextStyle == .body
        serifButton.isActive = currentTextStyle == .serif
        
        adjustScrollForTextStyle(style: currentTextStyle)
        
        boldButton.isActive = isBold
        italicButton.isActive = isItalics
        underlineButton.isActive = isUnderline
        strikethroughButton.isActive = hasStrikethrough
        
        leftIndentButton.isEnabled = !disableLeftIndent
        rightIndentButton.isEnabled = !disableRightIndent
        
        // Dynamic colors [Colors with Dark Mode] when retrieved back from CoreData doesn't compare with UIColors even if they are same
        // but if compared with their cgcolors then they compare the same.
        
        if let selectedTextColor = textColor, let transformedColor = textColorMap.filter({$0.appliedColor.cgColor == selectedTextColor.cgColor}).first, textColors.contains(transformedColor.visualColor){
            textColorPicker.selectedColor = transformedColor.visualColor
        }
        
        if let selectedHighlightColor = highlighColor, let transformedColor = highlightColorMap.filter({$0.appliedColor.cgColor == selectedHighlightColor.cgColor}).first, highLightColors.contains(transformedColor.visualColor){
            highlightColorPicker.selectedColor = transformedColor.visualColor
        }
        
        leftAlignButton.isActive = textAlignment == .left
        centerAlignButton.isActive = textAlignment == .center
        rightAlignButton.isActive = textAlignment == .right
        
    }
    
    // MARK: - Setup Keyboard Layout
    
    private func setupStyleKeyboard(){
        setupBoldItalicUnderlineButtons()
        setupTextAlignmentStack()
        setupIndentButtons()
        setupTextStyleScrollView()
        setupColorStack()
        setupCompleteStack()
    }
    
    private func setupBoldItalicUnderlineButtons(){
        let bImage = UIImage(systemName: "bold", withConfiguration: iconConfig)
        boldButton.setImage(bImage, for: .normal)
        boldButton.isActive = false
        
        let iImage = UIImage(systemName: "italic", withConfiguration: iconConfig)
        italicButton.setImage(iImage, for: .normal)
        italicButton.isActive = false
        
        let uImage = UIImage(systemName: "underline", withConfiguration: iconConfig)
        underlineButton.setImage(uImage, for: .normal)
        underlineButton.isActive = false
        
        let sImage = UIImage(systemName: "strikethrough", withConfiguration: iconConfig)
        strikethroughButton.setImage(sImage, for: .normal)
        strikethroughButton.isActive = false
        
        formatingStack.addArrangedSubview(boldButton)
        formatingStack.addArrangedSubview(italicButton)
        formatingStack.addArrangedSubview(underlineButton)
        formatingStack.addArrangedSubview(strikethroughButton)
        
        formatingStack.spacing = buttonSpacing
        formatingStack.distribution = .fillEqually
        
        boldButton.constrainHeight(constant: buttonHeight)
        italicButton.constrainHeight(constant: buttonHeight)
        underlineButton.constrainHeight(constant: buttonHeight)
        strikethroughButton.constrainHeight(constant: buttonHeight)
        
        boldButton.layer.cornerRadius = buttonCornerRadius
        boldButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        strikethroughButton.layer.cornerRadius = buttonCornerRadius
        strikethroughButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setupTextAlignmentStack(){
        let leftAlignImage = UIImage(systemName: "text.alignleft", withConfiguration: iconConfig)
        leftAlignButton.setImage(leftAlignImage, for: .normal)
        leftAlignButton.isActive = false
        
        let centerAlignImage = UIImage(systemName: "text.aligncenter", withConfiguration: iconConfig)
        centerAlignButton.setImage(centerAlignImage, for: .normal)
        centerAlignButton.isActive = false
        
        let rightAlignImage = UIImage(systemName: "text.alignright", withConfiguration: iconConfig)
        rightAlignButton.setImage(rightAlignImage, for: .normal)
        rightAlignButton.isActive = false
        
        for alignButton in [leftAlignButton, centerAlignButton, rightAlignButton]{
            alignButton.constrainHeight(constant: buttonHeight)
            alignButton.constrainWidth(constant: buttonWidth - 10)
            textAlignmentStack.addArrangedSubview(alignButton)
        }
        
        leftAlignButton.layer.cornerRadius = buttonCornerRadius
        leftAlignButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        rightAlignButton.layer.cornerRadius = buttonCornerRadius
        rightAlignButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        
        textAlignmentStack.spacing = buttonSpacing
        textAlignmentStack.distribution = .fillEqually
    }
    
    private func setupIndentButtons(){
        // Indent Buttons
        let leftImage = UIImage(systemName: "decrease.indent", withConfiguration: iconConfig)
        let rightImage = UIImage(systemName: "increase.indent", withConfiguration: iconConfig)
        
        leftIndentButton.setImage(leftImage, for: .normal)
        rightIndentButton.setImage(rightImage, for: .normal)
        
        leftIndentButton.isHighlighted = true
        leftIndentButton.isHighlighted = false
        
        rightIndentButton.isHighlighted = true
        rightIndentButton.isHighlighted = false
        
        leftIndentButton.constrainWidth(constant: buttonWidth)
        rightIndentButton.constrainWidth(constant: buttonWidth)
        
        leftIndentButton.constrainHeight(constant: buttonHeight)
        rightIndentButton.constrainHeight(constant: buttonHeight)
        
        leftIndentButton.isEnabled = false
        
        indentStack.addArrangedSubview(leftIndentButton)
        indentStack.addArrangedSubview(rightIndentButton)
        
        indentStack.spacing = buttonSpacing
        
        leftIndentButton.layer.cornerRadius = buttonCornerRadius
        leftIndentButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        rightIndentButton.layer.cornerRadius = buttonCornerRadius
        rightIndentButton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    private func setupTextStyleScrollView(){
        
        titleButton.label.text = "Title"
        titleButton.label.font = NotesFontProvider.shared.titleFont
        titleButton.layer.cornerRadius = buttonCornerRadius
        titleButton.constrainHeight(constant: buttonHeight)
        
        headingButton.label.text = "Heading"
        headingButton.label.font = NotesFontProvider.shared.headingFont
        headingButton.layer.cornerRadius = buttonCornerRadius
        headingButton.constrainHeight(constant: buttonHeight)
        
        bodyButton.label.text = "Body"
        
        
        let bodyFontDescriptor = NotesFontProvider.shared.bodyFont.fontDescriptor
        var bodyTraits = bodyFontDescriptor.symbolicTraits
        bodyTraits.update(with: .traitBold)
        if let boldBodyFontDescriptor = bodyFontDescriptor.withSymbolicTraits(bodyTraits){
            let boldBodyFont = UIFont(descriptor: boldBodyFontDescriptor, size: 0)
            bodyButton.label.font = boldBodyFont
        } else {
            bodyButton.label.font = NotesFontProvider.shared.bodyFont
        }
        
        bodyButton.layer.cornerRadius = buttonCornerRadius
        bodyButton.constrainHeight(constant: buttonHeight)
        
        serifButton.label.text = "Serif"
        
        let serifFontDescriptor = NotesFontProvider.shared.serifFont.fontDescriptor
        var serifTraits = serifFontDescriptor.symbolicTraits
        serifTraits.update(with: .traitBold)
        if let boldSerifFontDescriptor = serifFontDescriptor.withSymbolicTraits(serifTraits){
            let boldSerifFont = UIFont(descriptor: boldSerifFontDescriptor, size: 0)
            serifButton.label.font = boldSerifFont
        } else {
            serifButton.label.font = NotesFontProvider.shared.serifFont
        }
        
        serifButton.layer.cornerRadius = buttonCornerRadius
        serifButton.constrainHeight(constant: buttonHeight)
        
        titleButton.isActive = false
        headingButton.isActive = false
        bodyButton.isActive = true
        serifButton.isActive = false
        
        textStyleStack.addArrangedSubview(titleButton)
        textStyleStack.addArrangedSubview(headingButton)
        textStyleStack.addArrangedSubview(bodyButton)
        textStyleStack.addArrangedSubview(serifButton)
        
        textStyleStack.spacing = 5
        
        let scrollContentView = UIView()
        scrollContentView.backgroundColor = .clear
        
        styleScrollView.showsHorizontalScrollIndicator = false
        styleScrollView.showsVerticalScrollIndicator = false
        
        styleScrollView.addSubview(scrollContentView)
        scrollContentView.fillSuperview()
        let contentWidth = scrollContentView.widthAnchor.constraint(equalTo: styleScrollView.widthAnchor, multiplier: 1)
        let contentHeight = scrollContentView.heightAnchor.constraint(equalTo: styleScrollView.heightAnchor, multiplier: 1, constant: 0)
        contentWidth.priority = UILayoutPriority(250)
        NSLayoutConstraint.activate([contentWidth, contentHeight])
        
        scrollContentView.addSubview(textStyleStack)
        textStyleStack.fillSuperview()
        
        gradientMask.frame = scrollContainerView.bounds
        let gradientColors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientMask.colors = gradientColors
        gradientMask.startPoint = CGPoint(x: 0, y: 1)
        gradientMask.endPoint = CGPoint(x: 1, y: 1)
        gradientMask.locations = [0, 0.05, 0.95, 1]
        
        scrollContainerView.layer.mask = gradientMask
    }
    
    private func setupColorStack(){
        
        // setup segmented Control
        let textIcon = UIImage(systemName: "textformat.abc", withConfiguration: iconConfig)
        let hightlightIcon = UIImage(systemName: "pencil.tip.crop.circle", withConfiguration: iconConfig)
        
        colorSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.secondaryLabel], for: .normal)
        colorSegmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.label], for: .selected)
        
        colorSegmentControl.setImage(textIcon, forSegmentAt: 0)
        colorSegmentControl.setImage(hightlightIcon, forSegmentAt: 1)
        
        colorSegmentControl.constrainHeight(constant: buttonHeight)
        colorSegmentControl.constrainWidth(constant: 105)
        
        //setup Text Color Picker
        textColorPicker.colorChoices = textColors
        if let firstColor = textColors.first{
            textColorPicker.selectedColor = firstColor
        }
        
        // setup HighLight Color Picker
        highlightColorPicker.colorChoices = highLightColors
        if let firstColor = highLightColors.first{
            highlightColorPicker.selectedColor = firstColor
        }
        
        let paddingView = UIView()
        paddingView.constrainWidth(constant: 20)
        
        for subview in [colorSegmentControl, textColorPicker, highlightColorPicker, paddingView]{
            colorStack.addArrangedSubview(subview)
        }
        
        colorStack.spacing = 8
        
        // select the textColor in segmented control and hide the highlight picker
        colorSegmentControl.selectedSegmentIndex = 0
        highlightColorPicker.isHidden = true
        
        colorSegmentControl.addTarget(self, action: #selector(segmentedControllChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControllChanged(){
        if colorSegmentControl.selectedSegmentIndex == 0{
            textColorPicker.isHidden = false
            highlightColorPicker.isHidden = true
        } else {
            textColorPicker.isHidden = true
            highlightColorPicker.isHidden = false
        }
    }
    
    private func setupCompleteStack(){
        
        let spacer1 = UIView()
        spacer1.constrainWidth(constant: 10)
        
        let formattingStack = UIStackView(arrangedSubviews: [formatingStack, spacer1])
        formattingStack.spacing = 20
        
        let spacer2 = UIView()
        spacer2.constrainWidth(constant: 10)
        
        let alignmentAndIndentStack = UIStackView(arrangedSubviews: [textAlignmentStack, indentStack, spacer2])
        alignmentAndIndentStack.spacing = 20
        
        completeStack.addArrangedSubview(formattingStack)
        completeStack.addArrangedSubview(alignmentAndIndentStack)
        completeStack.addArrangedSubview(colorStack)
        completeStack.axis = .vertical
        completeStack.spacing = 20
        
    }
    
    private func setupReturnButton(){
        let crossImage = UIImage(systemName: "xmark", withConfiguration: iconConfig)
        returnButton.setImage(crossImage, for: .normal)
        returnButton.tintColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
        
        addSubview(returnButton)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        returnButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10))
        returnButton.constrainHeight(constant: 44)
        returnButton.constrainWidth(constant: 44)
    }
    
    private func adjustScrollForTextStyle(style: NotesTextView.TextStyle){
        
        let leftInset = styleScrollView.contentInset.left
        let rightInset = styleScrollView.contentInset.right
        let scrollWidth = styleScrollView.frame.width
        let currentOffsetX = styleScrollView.contentOffset.x
        
        let activeButtonStart: CGFloat
        let activeButtonEnd: CGFloat
        
        
        switch style {
        case .title:
            activeButtonStart = titleButton.frame.origin.x
            activeButtonEnd = activeButtonStart + titleButton.frame.width
        case .heading:
            activeButtonStart = headingButton.frame.origin.x
            activeButtonEnd = activeButtonStart + headingButton.frame.width
        case .body:
            activeButtonStart = bodyButton.frame.origin.x
            activeButtonEnd = activeButtonStart + bodyButton.frame.width
        case .serif:
            activeButtonStart = serifButton.frame.origin.x
            activeButtonEnd = activeButtonStart + serifButton.frame.width
        }
        
        // activeButton is outside the scroll view on left side
        if currentOffsetX > activeButtonStart{
            styleScrollView.setContentOffset(.init(x: activeButtonStart - leftInset, y: 0), animated: true)
        }
        
        // activeButton is outside the scroll view on right side
        if currentOffsetX < activeButtonStart && currentOffsetX + scrollWidth < activeButtonEnd{
            let adjustmentX = activeButtonEnd - (currentOffsetX + scrollWidth) + rightInset
            styleScrollView.setContentOffset(.init(x: currentOffsetX + adjustmentX, y: 0), animated: true)
        }
    }
    
}

extension TextStyleKeyboardView: ColorPickerViewDelegate{
    
    func didSelectColor(colorPicker: ColorPickerView, selectedColor: UIColor) {
        if colorPicker == textColorPicker{
            
            if let appliedTransformedColor = textColorMap.filter({$0.visualColor == selectedColor}).first{
                delegate?.didSelectTextColor(selectedColor: appliedTransformedColor.appliedColor)
            }
        } else if colorPicker == highlightColorPicker{
            
            if let appliedTransformedColor = highlightColorMap.filter({$0.visualColor == selectedColor}).first{
                delegate?.didSelectHighlightColor(selectedColor: appliedTransformedColor.appliedColor)
            }
        }
    }
    
}
