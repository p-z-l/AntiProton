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
    
    var appearanceChangeObservation: NSKeyValueObservation?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        if NSApp.windows.isEmpty {
            let _ = newEditorWindow()
        }
        appearanceChangeObservation = NSApp.observe(\.effectiveAppearance) { (app, _) in
            NotificationCenter.default.post(Notification(name: .appearanceChanged))
        }
    }
    
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
    
    @IBAction func new(_ sender: NSMenuItem) {
        let _ = newEditorWindow()
    }
    
    @IBAction func showPrefs(_ sender: NSMenuItem) {
        let prefsWC = PreferencesWindowController.shared
        prefsWC.window?.makeKeyAndOrderFront(self)
    }
    
    // open a new editor window
    private func newEditorWindow() -> EditorWindowController {
        let storyboard = NSStoryboard(name: "Editor", bundle: nil)
        let editorWC = storyboard.instantiateController(withIdentifier: "EditorWindowController") as! EditorWindowController
        editorWC.window?.makeKeyAndOrderFront(self)
        return editorWC
    }
    
    private func changeFontSize(by dSize: CGFloat) {
        if let editorVC = NSApplication.shared.mainWindow?.contentViewController as? EditorViewController {
            Preferences.changeFontSize(by: dSize)
            editorVC.contentTextView.font = Preferences.font
        }
    }
}
