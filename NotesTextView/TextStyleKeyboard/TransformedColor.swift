//
//  TransformedColor.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

// This is used to show a different shade of a color in ColorPicker.
// It is helpful when a shade which is shown in picker is different from one which is applied to the text.
// We noticed that when we show the exact shade in the color picker it doesn't look right but feels right when applied to the text.
// Hence this struct is used to map the shade in the color picker with applied color

struct TransformedColor{
    let visualColor: UIColor // the color which will be shown in Color Picker
    let appliedColor: UIColor // the color which will be applied to the text
}
