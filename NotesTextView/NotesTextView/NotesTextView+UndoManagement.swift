//
//  NotesTextView+UndoManagement.swift
//  NotesTextView
//
//  Created by Rimesh Jotaniya on 29/05/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit

extension NotesTextView{
    
    //MARK: - Undo Action
    
    // Supporting undo action is tricky because when we apply certain property like changing the text to Title Font, we might be losing some attributes like the parts where the text was italics and etc. There are so many possibilities to keep track of. Again keeping it simple I think undo is the action which remembers what was the cursor position and what was the content when any TextAction was performed.
    // This implementation has a limitation that I am not able to do redo action. [Redo is the undo of undo]
    
    private func revertChange(state: TextState){
        attributedText = state.attributedText
        selectedRange = state.selectedRange
        updateVisualForKeyboard()
    }
    
     func saveCurrentStateAndRegisterForUndo(){
        let currentState = TextState(selectedRange: selectedRange, attributedText: attributedText)
        undoManager?.registerUndo(withTarget: self, handler: { (_) in
            self.revertChange(state: currentState)
        })
    }
    
}
