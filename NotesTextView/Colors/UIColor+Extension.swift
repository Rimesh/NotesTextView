//
//  UIColor+Extension.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit
import Foundation
extension UIColor {
    
    static var grayBackgroundNormal: UIColor = {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.14)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07)
            }
        }
    }()
    
    static var grayBackgroundSelected: UIColor = {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3)
            } else {
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.14)
            }
        }
    }()
    
    
    
    static var FETextRed: UIColor = {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0.8953296233, green: 0.2821619954, blue: 0.1392149411, alpha: 1)
            } else {
                return #colorLiteral(red: 0.770708476, green: 0.07279348704, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var FETextBlue: UIColor = {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0.08686079848, green: 0.5644791946, blue: 0.8988120719, alpha: 1)
            } else {
                return #colorLiteral(red: 0, green: 0.379513749, blue: 0.6451733733, alpha: 1)
            }
        }
    }()
    
    static var FETextGreen: UIColor = {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0.3216672265, green: 0.8480317887, blue: 0, alpha: 1)
            } else {
                return #colorLiteral(red: 0.2004328773, green: 0.5284139555, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var FETextOrange: UIColor = {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 1)
            } else {
                return #colorLiteral(red: 0.7457312051, green: 0.3481137785, blue: 0, alpha: 1)
            }
        }
    }()
    
    static var FEHighlightOrange: UIColor = {
        
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 1, green: 0.6235294118, blue: 0.03921568627, alpha: 0.3031892123)
            } else {
                return #colorLiteral(red: 0.750187286, green: 0.4677638372, blue: 0.02941910925, alpha: 0.3031892123)
            }
        }
    }()
    
    static var FEHighlightGreen: UIColor = {

        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0.1568627451, green: 0.8039215686, blue: 0.2549019608, alpha: 0.3)
            } else {
                return #colorLiteral(red: 0.1630943373, green: 0.7013056507, blue: 0.2446415061, alpha: 0.3035370291)
            }
        }
    }()
    
    static var FEHighlightBlue: UIColor = {
        
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.2998180651)
            } else {
                return #colorLiteral(red: 0.02943799523, green: 0.388581537, blue: 0.7506688784, alpha: 0.2998180651)
            }
        }
    }()
    
    static var FEHighlightRed: UIColor = {
        
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 0.2979184503)
            } else {
                return #colorLiteral(red: 0.7485552226, green: 0.2025502367, blue: 0.1702596193, alpha: 0.2979184503)
            }
        }
    }()
    
    static var notesBackground: UIColor = {
        
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark{
                return .black
            } else {
                return #colorLiteral(red: 0.9999004006, green: 1, blue: 0.878303647, alpha: 1)
            }
        }
    }()
}
