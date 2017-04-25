//
//  TaskTextView.swift
//  Batman
//
//  Created by Romain Pouclet on 2017-04-22.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import Foundation

final class TaskTextStorage: NSTextStorage {
    private let backingStore = NSMutableAttributedString()
    
    override var string: String {
        return backingStore.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return backingStore.attributes(at: location, effectiveRange: range)
    }

    override func replaceCharacters(in range: NSRange, with str: String) {
        beginEditing()
        let beforeLength = length
        backingStore.replaceCharacters(in: range, with: str)
        edited(.editedAttributes, range: range, changeInLength: length - beforeLength)
        endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        beginEditing()
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
        endEditing()
    }
    
    override func processEditing() {
        let content = string as NSString

        setAttributes([NSFontAttributeName: UIFont.btmTaskNotesFont()], range: NSMakeRange(0, content.length))
        
        let range = NSMakeRange(0, content.length)
        content.enumerateSubstrings(in: range, options: .byLines) { (line, range, _, stop) in
            self.setAttributes([NSFontAttributeName: UIFont.btmTaskNameFont()], range: range)
            stop.pointee = true
        }

        super.processEditing()
    }
}

final class TaskTextView: UITextView {
    
    init() {
        let textContainer = NSTextContainer()
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = TaskTextStorage()
        textStorage.addLayoutManager(layoutManager)

        super.init(frame: .zero, textContainer: textContainer)
        
        textContainerInset = UIEdgeInsets(top: 32, left: 20, bottom: 20, right: 20)
        font = UIFont.btmTaskNameFont()
        
        isUserInteractionEnabled = true
        alwaysBounceVertical = true
        
        keyboardDismissMode = .onDrag
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
