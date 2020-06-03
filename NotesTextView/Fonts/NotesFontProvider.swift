//
//  NotesFontProvider.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

class NotesFontProvider{
    
    static let shared = NotesFontProvider()
    
    lazy var titleFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .bold))
    lazy var headingFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
    lazy var bodyFont = UIFont.preferredFont(forTextStyle: .body)
    
    lazy var serifFont: UIFont = {
        getSerifFont()
    }()
    
    private init(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(fontSizeChanged), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    @objc private func fontSizeChanged(){
        titleFont = UIFontMetrics(forTextStyle: .title1).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .bold))
        headingFont = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .bold))
        bodyFont = UIFont.preferredFont(forTextStyle: .body)
        serifFont = getSerifFont()
    }
    
    private func getSerifFont() -> UIFont {
        
//        if let serfFontDescriptor = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 17)).fontDescriptor.withDesign(.serif){
//            let serifFont = UIFont(descriptor: serfFontDescriptor, size: 0)
//            return serifFont
//        } else{
//            return .systemFont(ofSize: 10)
//        }
        
        // if we use system serif fonts i.e. fontDescriptor.withDesign(.serif)
        // then when retrieving the font back from CoreData, serif font wasn't identifiable. It might be a bug because of relatively new API and might get resolved in near future.
        
        // if we use named font then the same font is identifiable.
        // However Apple Discourages use of named font in WWDC 2019 - Font Management and Text Scaling
        // https://developer.apple.com/videos/play/wwdc2019/227/
        
        if let georgiaFont = UIFont(name: "Georgia", size: 18){
            return UIFontMetrics(forTextStyle: .body).scaledFont(for: georgiaFont)
        } else {
            return bodyFont
        }
    }
    
}
