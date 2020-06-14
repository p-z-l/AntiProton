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
    private var documentManager = DocumentManager()
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
    
    let highlightr = Highlightr()!
    var highlightedText: NSAttributedString {
        return highlightr.highlight(currentBuffer.text, as: currentBuffer.representedURL?.pathExtension, fastRender: false)!
    }
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        documentManager.didChangeData {
            self.sourceListOutlineView.reloadData()
        }
        contentTextView.isAutomaticQuoteSubstitutionEnabled = false
        
        highlightr.setTheme(to: "atom-one-dark")
    }
    
    // MARK: Private methods
    // open a file
    private func openURL(_ url: URL) {
        currentBuffer = EditorBuffer(filePath: url)
    }
    // returns an NSTableViewCell for sourceListTableView
    private func getTableViewCell(forPath fileURL: URL) -> NSTableCellView? {
        func indentCell(_ cell: NSTableCellView) {
            let dx = CGFloat(fileURL.levelComparedWith(documentManager.baseURL!))*16
            for subView in cell.subviews {
                subView.frame = CGRect(x: subView.frame.minX + dx,
                                       y: subView.frame.minY,
                                       width: subView.frame.width,
                                       height: subView.frame.height)
            }
        }
        let fileName = fileURL.lastPathComponent
        let fileTypeIcon = fileURL.fileIcon
        let identifier = NSUserInterfaceItemIdentifier("FileCell")
        guard let cell = sourceListOutlineView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else { return nil }
        cell.textField?.stringValue = fileName
        cell.imageView?.image = fileTypeIcon
        indentCell(cell)
        return cell
    }
    private func updateCodeHighlight() {
        let selections = contentTextView.selectedRanges
        let attributedString = highlightedText
        contentTextView.textStorage?.setAttributedString(attributedString)
        contentTextView.font = .SFMono(ofSize: Preferences.fontSize)
        contentTextView.selectedRanges = selections
        contentTextView.backgroundColor = highlightr.theme.themeBackgroundColor
        bufferListStackView.layer?.backgroundColor = contentTextView.backgroundColor.shadow(withLevel: 0.2)?.cgColor
    }
}

extension EditorViewController: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        // sync with the current buffer
        currentBuffer.text = contentTextView.string
        updateCodeHighlight()
    }
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        // insert spaces when tab key is pressed
        if commandSelector == #selector(insertTab(_:)) {
            textView.insertText("    ", replacementRange: textView.selectedRange())
            return true
        } else {
            return false
        }
    }
}

extension EditorViewController: NSOutlineViewDelegate, NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
//        return documentManager.files[index]
        return (item as? File)?.subDirectoryFiles?[index] ?? documentManager.files[index]
    }
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let dir = item as? File {
            return dir.subDirectoryFiles?.count ?? 0
        } else {
            return documentManager.files.count
        }
    }
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return (item as! File).url.isDirectory
    }
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        let url = (item as! File).url
        let identifier = NSUserInterfaceItemIdentifier("FileNameCell")
        let cell = outlineView.makeView(withIdentifier: identifier, owner: self) as! FileNameTableCellView
        cell.representedURL = (item as! File).url
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
