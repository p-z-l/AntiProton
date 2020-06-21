//
//  GeneralViewController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/20.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa
import Highlightr

class GeneralViewController: NSViewController {

    @IBOutlet weak var selectThemePopup: NSPopUpButton!
    
    @IBOutlet weak var fontField: NSTextField!
    
    @IBOutlet weak var btChooseFont: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpthemePopup()
        setUpFontChooser()
    }
    
    @IBAction func selectTheme(_ sender: NSPopUpButton) {
        Preferences.themeName = sender.selectedItem!.title
    }
    
    @IBAction func chooseFont(_ sender: NSButton) {
        NSFontPanel.shared.makeKeyAndOrderFront(self)
    }
    
    func fontChanged() {
        updateFontField()
    }
    
    private func setUpthemePopup() {
        selectThemePopup.removeAllItems()
        selectThemePopup.addItems(withTitles: Highlightr()!.availableThemes())
        selectThemePopup.selectItem(withTitle: Preferences.themeName)
    }
    
    private func setUpFontChooser() {
        fontField.isEditable = false
        
        updateFontField()
    }
    
    private func updateFontField() {
        fontField.font = Preferences.font
        fontField.stringValue = "\(Preferences.font.displayName!):\(Preferences.font.pointSize)"
        print("update!")
    }
}

