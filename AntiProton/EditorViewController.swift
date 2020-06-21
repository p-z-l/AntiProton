//
//  EditorViewController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/9.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa
import Highlightr

class EditorViewController: NSViewController {
    
    // MARK: Properties
    // UI elements
    @IBOutlet weak var bufferListStackView: NSStackView!
    @IBOutlet weak var sourceListOutlineView: NSOutlineView!
    @IBOutlet var contentTextView: NSTextView!
    
    // buffer & editor
    private let documentManager = DocumentManager()
    private(set) var openedBuffers = [EditorBuffer]()
    private(set) var currentBufferIndex : Int? {
        didSet {
            updateCodeHighlight()
        }
    }
    private(set) var currentBuffer : EditorBuffer {
        get {
            if currentBufferIndex != nil {
                return openedBuffers[currentBufferIndex!]
            } else {
                return EditorBuffer.empty
            }
        }
        set {
            // if buffer already exist:
            for i in 0..<openedBuffers.count {
                if openedBuffers[i].representedURL == newValue.representedURL {
                    currentBufferIndex = i
                    return
                }
            }
            // if buffer do not exist:
            openedBuffers.append(newValue)
            currentBufferIndex = openedBuffers.count-1
        }
    }
    override var representedObject: Any? {
        didSet {
            if let url = representedObject as? URL {
                documentManager.baseURL = url
            }
        }
    }
    // syntax highlight
    let highlightr = Highlightr()!
    var highlightedText: NSAttributedString {
        if currentBuffer.representedURL?.pathExtension != "txt" {
            return highlightr.highlight(currentBuffer.text, as: currentBuffer.representedURL?.pathExtension, fastRender: false)!
        } else {
            return NSAttributedString(string: currentBuffer.text, attributes: [
                .foregroundColor : NSColor.textColor
            ])
        }
    }
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentManager.didChangeData {
            self.sourceListOutlineView.reloadData()
        }
        contentTextView.isAutomaticQuoteSubstitutionEnabled = false
    }
    
    // MARK: Private methods
    // open a file
    private func openURL(_ url: URL) {
        if url.isPlainTextFile {
            currentBuffer = EditorBuffer(filePath: url)
        }
    }
    private func updateCodeHighlight() {
        highlightr.setTheme(to: Preferences.themeName)
        let selections = contentTextView.selectedRanges
        let attributedString = highlightedText
        contentTextView.textStorage?.setAttributedString(attributedString)
        contentTextView.font = Preferences.font
        contentTextView.selectedRanges = selections
        if currentBuffer.representedURL?.pathExtension != "txt" {
            contentTextView.backgroundColor = highlightr.theme.themeBackgroundColor
        } else {
            contentTextView.backgroundColor = .textBackgroundColor
        }
        bufferListStackView.layer?.backgroundColor = contentTextView.backgroundColor.shadow(withLevel: 0.2)?.cgColor
        
        contentTextView.insertionPointColor = highlightr.theme.themeBackgroundColor.inverted
    }
    
    func undo() {
        currentBuffer.undoManager.undo()
    }
    func redo() {
        currentBuffer.undoManager.redo()
    }
    
    private var dataChangeHandler: ()->Void = {}
    
    func didEdit(_ handler: @escaping ()->Void) {
        self.dataChangeHandler = handler
    }
}

extension EditorViewController: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        // sync with the current buffer
        currentBuffer.text = contentTextView.string
        updateCodeHighlight()
        
        dataChangeHandler()
    }
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        // register in undo manager
        // insert spaces when tab key is pressed
        if commandSelector == #selector(insertTab(_:)) {
            textView.insertText("    ", replacementRange: textView.selectedRange())
            return true
        } else {
            return false
        }
    }
    func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        return true
    }
}

extension EditorViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return (item as? URL)?.subdirectoryURLs?[index] ?? documentManager.urls[index]
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let directoryURL = item as? URL {
            return directoryURL.subdirectoryURLs?.count ?? 0
        } else {
            return documentManager.urls.count
        }
    }
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as! URL).isDirectory
    }
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let url = item as! URL
        let identifier = NSUserInterfaceItemIdentifier("FileNameCell")
        let cell = outlineView.makeView(withIdentifier: identifier, owner: self) as! FileNameTableCellView
        cell.representedURL = item as? URL
        cell.textField?.stringValue = url.lastPathComponent
        cell.imageView?.image = url.fileIcon
        return cell
    }
    func outlineViewSelectionDidChange(_ notification: Notification) {
        let row = sourceListOutlineView.selectedRow
        let column = sourceListOutlineView.selectedColumn
        let selectedCell = sourceListOutlineView.view(atColumn: column, row: row, makeIfNecessary: false) as! FileNameTableCellView
        let url = selectedCell.representedURL!
        openURL(url)
    }
}
