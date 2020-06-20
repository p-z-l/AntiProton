//
//  PreferencesWindowController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/20.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

fileprivate let sharedPrefsWC = NSStoryboard(name: "Preferences", bundle: nil)
    .instantiateController(withIdentifier: "PreferencesWindowController") as! PreferencesWindowController

class PreferencesWindowController: NSWindowController {
    
    static var shared : PreferencesWindowController {
        return sharedPrefsWC
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }

}
