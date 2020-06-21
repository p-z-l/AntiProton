//
//  PreferencesTabViewController.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/21.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class PreferencesTabViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension PreferencesTabViewController: NSFontChanging {
    func changeFont(_ sender: NSFontManager?) {
        guard sender != nil else { return }
        if let generalVC = self.tabView.tabViewItem(at: 0).viewController as? GeneralViewController {
            generalVC.fontChanged()
        }
        Preferences.font = sender!.convert(Preferences.font)
    }
}
