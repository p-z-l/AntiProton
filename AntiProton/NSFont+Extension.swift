//
//  NSFont+Extension.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/12.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

extension NSFont {
    static func SFMono(ofSize size: CGFloat) -> NSFont {
        let sfMonoDescriptor = NSFont.systemFont(ofSize: 0).fontDescriptor.withDesign(.monospaced)!
        let sfMonoFont = NSFont(descriptor: sfMonoDescriptor, size: size)!
        return sfMonoFont
    }
    
    func changeSize(to size: CGFloat) -> NSFont {
        return NSFont(descriptor: self.fontDescriptor, size: size)!
    }
    
    func saveToUserDefaults(forKey key: String) {
        let nameKey = "\(key)_name"
        let sizeKey = "\(key)_size"
        
        UserDefaults.standard.set(self.fontName, forKey: nameKey)
        UserDefaults.standard.set(self.pointSize, forKey: sizeKey)
    }
    
    static func loadFromUserDefaults(forKey key: String) -> NSFont? {
        let nameKey = "\(key)_name"
        let sizeKey = "\(key)_size"
        
        guard let name = UserDefaults.standard.string(forKey: nameKey) else {
            return nil
        }
        let size = CGFloat(UserDefaults.standard.float(forKey: sizeKey))
        guard size != 0 else {
            return nil
        }
        
        return NSFont(name: name, size: CGFloat(size))
    }
}

