//
//  Preferences.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/13.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class Preferences: NSObject {
    override private init() {}
    
    struct keys {
        static let themeName = "AntiProton_themeName"
        static let font = "AntiProton_font"
    }
    
    struct defaultValues {
        static let themeName = "atom-one-dark"
        static let font: NSFont = NSFont.SFMono(ofSize: NSFont.systemFontSize)
    }
    
    static var themeName: String {
        get {
            if let result = UserDefaults.standard.string(forKey: Preferences.keys.themeName) {
                return result
            } else {
                return Preferences.defaultValues.themeName
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Preferences.keys.themeName)
        }
    }
    
    static var font: NSFont {
        get {
            if let font = NSFont.loadFromUserDefaults(forKey: Preferences.keys.font) {
                return font
            } else {
                return Preferences.defaultValues.font
            }
        }
        set {
            newValue.saveToUserDefaults(forKey: Preferences.keys.font)
        }
    }
    
    static func changeFontSize(by dSize: CGFloat) {
        let currentFont = Preferences.font
        let currentSize = Preferences.font.pointSize
        
        Preferences.font = currentFont.changeSize(to: currentSize + dSize)
    }
}
