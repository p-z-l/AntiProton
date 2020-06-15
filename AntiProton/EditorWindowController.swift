//
//  EditorWindowController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/9.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class EditorWindowController: NSWindowController {
    
    private var editorVC : EditorViewController {
        guard let editorViewController = self.contentViewController as? EditorViewController else { fatalError() }
        return editorViewController
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // avoid windows overlapping with each other
        self.shouldCascadeWindows = true
    }
    
    override func windowDidLoad() {
        editorVC.didEdit {
            self.window?.isDocumentEdited = true
        }
    }
    
    // show open document panel
    func openDocument(_ handler: @escaping (URL?)->Void) {
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
            handler(openPanel.url)
        }
    }
    @IBAction func saveDocument(_ sender: AnyObject?) {
        editorVC.currentBuffer.saveFile()
        for buffer in editorVC.openedBuffers {
            if buffer.isDirty {
                return
            }
        }
        self.window?.isDocumentEdited = false
    }
    func openURL(_ url: URL) {
        if url.isDirectory {
            self.contentViewController?.representedObject = url
        }
    }
    
    public func haha() {
        print("haha")
    }
}
