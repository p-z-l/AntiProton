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
    
    @IBOutlet weak var appearancePopup: NSPopUpButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpthemePopup()
        setUpFontChooser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFontField), name: .fontChanged, object: nil)
    }
    
    @IBAction func selectTheme(_ sender: NSPopUpButton) {
        Preferences.themeName = sender.selectedItem!.title
    }
    
    @IBAction func chooseFont(_ sender: NSButton) {
        NSFontPanel.shared.makeKeyAndOrderFront(self)
    }
    @IBAction func selectAppearance(_ sender: NSPopUpButton) {
        let rawValue = sender.indexOfSelectedItem
        if let appearance = Preferences.Appearance(rawValue: rawValue) {
            Preferences.appearance = appearance
        }
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
    
    private func setupAppearancePopup() {
        appearancePopup.selectItem(withTitle: "")
    }
    
    @objc private func updateFontField() {
        let font = Preferences.font
        let displayFont = NSFont(descriptor: font.fontDescriptor, size: NSFont.systemFontSize)
        fontField.font = displayFont
        fontField.stringValue = "\(font.displayName!):\(font.pointSize)"
    }
}

