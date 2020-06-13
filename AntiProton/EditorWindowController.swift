//
//  EditorWindowController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/9.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class EditorWindowController: NSWindowController {
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		self.shouldCascadeWindows = true
	}
	func openDocument(_ sender: AnyObject?) {
		let openPanel = NSOpenPanel()
		openPanel.showsHiddenFiles = false
		openPanel.canChooseFiles = false
		openPanel.canChooseDirectories = true
		
		openPanel.beginSheetModal(for: self.window!) { response in
			guard response.rawValue == NSApplication.ModalResponse.OK.rawValue else {
				return
			}
			self.contentViewController?.representedObject = openPanel.url
			self.window?.title = openPanel.url!.lastPathComponent
		}
	}
	@IBAction func saveDocument(_ sender: AnyObject?) {
		guard let editorViewController = self.contentViewController as? EditorViewController else { return }
		editorViewController.currentBuffer.saveFile()
	}
}
