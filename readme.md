# NotesTextView
### iOS Notes style formatting for UITextView using NSAttributedString

![iPhone iPad Screenshots](/screenshots.jpg)

# Features
* Custom Keyboard
* Accessory View
* iPad Support
* Dark Mode Support
* Font Styles
    * Title
    * Heading
    * Body
    * Serif
* Text Formatting
    * Bold
    * Italics
    * Underline
    * Strikethrough
* Text Alignment
* Text Indents
* Text Colors
* Text Highlights
* Undo Management

# How to use
* Add NotesTextView framework to your project. [See how to do this here](https://www.youtube.com/watch?v=GMYxlkOE35k)
* `import NoteTextView` in your ViewController and use the code below

```Swift

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
```

### Apps Using NotesTextView
* [Visits Journal](https://visits.app/download/) by Rohan Merchant


### Contributions

I'm always looking to improve this project. If you would like to contribute fork the repo and open a pull request with your changes.

### Author
[Rimesh Jotaniya](https://twitter.com/RecursiveSwift) 

### Licence
Copyright (c) 2020 Rimesh Jotaniya <rimesh.j@icloud.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.


