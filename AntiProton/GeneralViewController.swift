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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpthemePopup()
    }
    
    @IBAction func selectTheme(_ sender: NSPopUpButton) {
        Preferences.themeName = sender.selectedItem!.title
    }
    
    private func setUpthemePopup() {
        selectThemePopup.removeAllItems()
        selectThemePopup.addItems(withTitles: Highlightr()!.availableThemes())
        selectThemePopup.selectItem(withTitle: Preferences.themeName)
    }
}

