//
//  ViewController.swift
//  TextDemo
//
//  Created by Rimesh Jotaniya on 03/06/20.
//  Copyright © 2020 Rimesh Jotaniya. All rights reserved.
//

import UIKit
import NotesTextView

class ViewController: UIViewController {
    
    let textView = NotesTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // to adjust the content insets based on keyboard height
        textView.shouldAdjustInsetBasedOnKeyboardHeight = true
        
        // to support iPad
        textView.hostingViewController = self
        
        let _ = textView.becomeFirstResponder()
        
    }


}

