//
//  NSColor+Extension.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/20.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

extension NSColor {
    var isLightColor: Bool {
        let r = self.redComponent
        let g = self.greenComponent
        let b = self.blueComponent
        
        return r+g+b >= 3.0/2
    }
    var inverted: NSColor {
        return NSColor(red: 1.0-self.redComponent,
                       green: 1.0-self.greenComponent,
                       blue: 1.0-self.blueComponent,
                       alpha: self.alphaComponent)
    }
}
