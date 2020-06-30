//
//  Preferences.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/13.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

struct Preferences {
    
    private init() {}
    
    enum Appearance : Int {
        case system
            case light, dark
        
        var nsAppearance: NSAppearance {
            switch self {
            case .system:
                return NSApp.effectiveAppearance
            case .dark:
                return NSAppearance(named: .darkAqua)!
            case .light:
                return NSAppearance(named: .aqua)!
            }
        }
    }
    
    struct keys {
        static let themeName = "AntiProton_themeName"
        static let font = "AntiProton_font"
        static let appearance = "AntiProton_appearance"
    }
    
    struct defaultValues {
        static let themeName = "atom-one-dark"
        static let font: NSFont = NSFont.SFMono(ofSize: NSFont.systemFontSize)
        static let appearance = Preferences.Appearance.system
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
            NotificationCenter.default.post(Notification(name: .themeChanged))
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
            NotificationCenter.default.post(Notification(name: .fontChanged))
        }
    }
    
    static var appearance: Preferences.Appearance {
        get {
            let rawValue = UserDefaults.standard.integer(forKey: Preferences.keys.appearance)
            if let appearance = Preferences.Appearance(rawValue: rawValue) {
                return appearance
            } else {
                Preferences.appearance = .system
                return Preferences.defaultValues.appearance
            }
        }
        set {
            let rawValue = newValue.rawValue
            UserDefaults.standard.setValue(rawValue, forKey: Preferences.keys.appearance)
            NotificationCenter.default.post(Notification(name: .appearanceChanged))
        }
    }
    
    static func changeFontSize(by dSize: CGFloat) {
        let currentFont = Preferences.font
        let currentSize = Preferences.font.pointSize
        
        Preferences.font = currentFont.changeSize(to: currentSize + dSize)
    }
    
}
