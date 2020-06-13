//
//  EditorViewController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/9.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class EditorViewController: NSViewController {
	
	// MARK: Properties
	// UI elements
	@IBOutlet weak var bufferListStackView: NSStackView!
	@IBOutlet weak var sourceListTableView: NSTableView!
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
				documentManager.directoryURL = url
			}
		}
	}
	
	// MARK: ViewController Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		documentManager.didUpdate {
			self.sourceListTableView.reloadData()
		}
	}
	
	// MARK: Private methods
	// open a file
	private func openURL(_ url: URL) {
		currentBuffer = EditorBuffer(filePath: url)
	}
	// returns an NSTableViewCell for sourceListTableView
	private func getTableViewCell(forPath fileURL: URL) -> NSTableCellView? {
		func indentCell(_ cell: NSTableCellView) {
			let dx = CGFloat(fileURL.levelComparedWith(documentManager.directoryURL!))*16
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
		guard let cell = sourceListTableView.makeView(withIdentifier: identifier, owner: self) as? NSTableCellView else { return nil }
		cell.textField?.stringValue = fileName
		cell.imageView?.image = fileTypeIcon
		indentCell(cell)
		return cell
	}
	private func updateCodeHighlight() {
		let selections = contentTextView.selectedRanges
		let attributedString = currentBuffer.displayText
		contentTextView.textStorage?.setAttributedString(attributedString)
		contentTextView.selectedRanges = selections
	}
}

extension EditorViewController: NSTextViewDelegate {
	func textDidChange(_ notification: Notification) {
		currentBuffer.text = contentTextView.string
		updateCodeHighlight()
	}
}

extension EditorViewController: NSTableViewDelegate, NSTableViewDataSource {
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let fileURL = documentManager.fileURLs[row]
		return getTableViewCell(forPath: fileURL)
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
		return documentManager.fileURLs.count
	}
	func tableViewSelectionDidChange(_ notification: Notification) {
		let selectedRow = sourceListTableView.selectedRow
		guard selectedRow >= 0 && selectedRow < documentManager.fileURLs.count else { return }
		let fileURL = documentManager.fileURLs[selectedRow]
		openURL(fileURL)
	}
	
}
