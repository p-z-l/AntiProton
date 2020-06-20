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
        static let fontSize = "AntiProton_fontSize"
        static let themeName = "AntiProton_themeName"
    }
    
    struct defaultValues {
        static let fontSize : CGFloat = 12
        static let themeName = "atom-one-dark"
    }
    
    static var fontSize: CGFloat {
        get {
            let size = CGFloat(UserDefaults.standard.float(forKey: Preferences.keys.fontSize))
            if size >= 8 {
                return size
            } else {
                return Preferences.defaultValues.fontSize
            }
        }
        set {
            if newValue >= 8 {
                UserDefaults.standard.set(newValue, forKey: Preferences.keys.fontSize)
            }
        }
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
}
