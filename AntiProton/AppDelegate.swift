//
//  AppDelegate.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/9.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	private func newEditorWindow() -> EditorWindowController {
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		let editorWindowController = storyboard.instantiateController(withIdentifier: "EditorWindowController") as! EditorWindowController
		editorWindowController.window?.makeKeyAndOrderFront(self)
		editorWindowController.window?.makeMain()
		return editorWindowController
	}
	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if NSApplication.shared.mainWindow == nil {
			let _ = newEditorWindow()
		}
		return true
	}
	@IBAction func openDocument(_ sender: AnyObject?) {
		var currentEditorWindowController: EditorWindowController
		if NSApplication.shared.mainWindow == nil {
			currentEditorWindowController = newEditorWindow()
		} else {
			guard let windowController = NSApplication.shared.mainWindow!.windowController as? EditorWindowController else { return }
			currentEditorWindowController = windowController
		}
		currentEditorWindowController.openDocument(self)
	}
}
