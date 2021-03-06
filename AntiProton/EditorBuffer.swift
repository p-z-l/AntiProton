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
    
    // returns an empty buffer
    static let empty = EditorBuffer(filePath: nil)
    
    let undoManager = UndoManager()
    
    var representedURL : URL?
    var text = String() {
        didSet {
            isDirty = true
        }
    }
    
    var isDirty = false
    
    init(filePath: URL?) {
        representedURL = filePath
        guard representedURL != nil else { return }
        do {
            text = try String(contentsOf: representedURL!)
        } catch {
            print("failed to load file: \(representedURL!.path) while initializing EditorBuffer")
        }
    }
    
    func saveFile() {
        guard representedURL != nil else { return }
        do {
            try text.write(to: representedURL!, atomically: false, encoding: .utf8)
        } catch {
            print("failed to save file: \(representedURL!.path)")
        }
        isDirty = false
    }
    
    func revertToSave() {
        guard representedURL != nil else { return }
        do {
            text = try String(contentsOf: representedURL!)
        } catch {
            print("failed to load file: \(representedURL!.path) while reverting to save")
        }
    }
}
