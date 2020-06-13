//
//  EditorBuffer.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/12.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa
import Highlightr

class EditorBuffer: NSObject {
	
	static let empty = EditorBuffer(filePath: nil)
	
	let highlighter = Highlightr()!
	
	var representedURL : URL?
	var text = String()
	
	init(filePath: URL?) {
		representedURL = filePath
		guard representedURL != nil else { return }
		do {
			text = try String(contentsOf: representedURL!)
		} catch {
			print("failed to load file: \(representedURL!.path)")
		}
	}
	
	func saveFile() {
		guard representedURL != nil else { return }
		do {
			try text.write(to: representedURL!, atomically: false, encoding: .utf8)
		} catch {
			print("failed to save file: \(representedURL!.path)")
		}
	}
	
	func revertToSave() {
		guard representedURL != nil else { return }
		do {
			text = try String(contentsOf: representedURL!)
		} catch {
			print("failed to load file: \(representedURL!.path)")
		}
	}
	
	var displayText : NSAttributedString {
		for theme in highlighter.availableThemes() {
			print(theme)
		}
		highlighter.setTheme(to: "atom-one-dark")
		if let result = highlighter.highlight(text, as: representedURL?.pathExtension, fastRender: true) {
			return result
		} else {
			return NSAttributedString(string: text)
		}
	}
	
	var backgroundColor: NSColor {
		return highlighter.theme.themeBackgroundColor
	}
}
