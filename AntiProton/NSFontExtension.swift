//
//  NSFontExtension.swift
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
}

