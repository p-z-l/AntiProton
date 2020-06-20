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
    }
    
    static var fontSize: CGFloat {
        get {
            let size = CGFloat(UserDefaults.standard.float(forKey: Preferences.keys.fontSize))
            if size >= 8 {
                return size
            } else {
                return 12
            }
        }
        set {
            if newValue >= 8 {
                UserDefaults.standard.set(newValue, forKey: Preferences.keys.fontSize)
            }
        }
    }
}
