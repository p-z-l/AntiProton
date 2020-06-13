//
//  NSFontExtension.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/12.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

extension NSFont {
    static var SFMono: NSFont {
        let sfMonoDescriptor = NSFont.systemFont(ofSize: 0).fontDescriptor.withDesign(.monospaced)!
        let sfMonoFont = NSFont(descriptor: sfMonoDescriptor, size: 0)!
        return sfMonoFont
    }
}
