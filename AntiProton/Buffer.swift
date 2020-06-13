//
//  EditorBuffer.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/12.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class EditorBuffer: NSObject {
	var representedURL : URL?
	var currentText = String()
	init(filePath: URL?) {
		self.representedURL = filePath
		guard self.representedURL != nil else { return }
		do {
			self.currentText = try String(contentsOf: self.representedURL!)
		} catch {
			print("failed to initialize buffer")
		}
	}
	override init() {}
	func saveFile() {
		guard representedURL != nil else { return }
		do {
			try currentText.write(to: representedURL!, atomically: false, encoding: .utf8)
		} catch {
			print("failed to save file")
		}
	}
}
