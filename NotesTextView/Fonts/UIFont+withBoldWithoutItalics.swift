//
//  UIFont+withBoldWithoutItalics.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit


extension UIFont{
    
    func withBoldWithoutItalics() -> UIFont{
        
        var curentTraits = self.fontDescriptor.symbolicTraits
        
        // add bold
        if !curentTraits.contains(.traitBold){
            curentTraits.update(with: .traitBold)
        }
        
        // remove italics
        if curentTraits.contains(.traitItalic){
            curentTraits.remove(.traitItalic)
        }
        
        guard let updatedDescriptor = self.fontDescriptor.withSymbolicTraits(curentTraits) else {
            return self
        }
        
        let updatedFont = UIFont(descriptor: updatedDescriptor, size: 0)
        
        return updatedFont
    }
}
