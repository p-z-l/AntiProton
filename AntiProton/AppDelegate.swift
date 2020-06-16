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
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        // When click on dock icon, open a new window if needed
        if NSApplication.shared.mainWindow == nil {
            let _ = newEditorWindow()
        }
        return true
    }
    
    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        for filename in filenames {
            let url = URL(fileURLWithPath: filename)
            let editorWC = newEditorWindow()
            editorWC.openURL(url)
        }
    }
    
    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        let url = URL(fileURLWithPath: filename)
        let editorWC = newEditorWindow()
        editorWC.openURL(url)
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
        currentEditorWindowController.openDocument { url in
            if url != nil {
                NSDocumentController.shared.noteNewRecentDocumentURL(url!)
            }
        }
    }
    
    @IBAction func saveAllDocuments(_ sender: AnyObject?) {
        if let editorWC = NSApplication.shared.mainWindow?.windowController as? EditorWindowController {
            editorWC.saveAllDocuments(self)
        }
    }
    
    @IBAction func fontBigger(_ sender: NSMenuItem) {
        changeFontSize(by: +1)
    }
    
    @IBAction func fontSmaller(_ sender: NSMenuItem) {
        changeFontSize(by: -1)
    }
    
    @IBAction func undo(_ sender: NSMenuItem) {
        if let editorVC = NSApplication.shared.mainWindow?.contentViewController as? EditorViewController {
            editorVC.undo()
        }
    }
    
    @IBAction func redo(_ sender: NSMenuItem) {
        if let editorVC = NSApplication.shared.mainWindow?.contentViewController as? EditorViewController {
            editorVC.redo()
        }
    }
    
    // open a new editor window
    private func newEditorWindow() -> EditorWindowController {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let editorWindowController = storyboard.instantiateController(withIdentifier: "EditorWindowController") as! EditorWindowController
        editorWindowController.window?.makeKeyAndOrderFront(self)
        editorWindowController.window?.makeMain()
        return editorWindowController
    }
    
    private func changeFontSize(by dSize: CGFloat) {
        if let editorVC = NSApplication.shared.mainWindow?.contentViewController as? EditorViewController {
            let currentFont = editorVC .contentTextView.font!
            Preferences.fontSize = currentFont.pointSize + dSize
            let font = currentFont.changeSize(to: Preferences.fontSize)
            editorVC .contentTextView.font = font
        }
    }
}
