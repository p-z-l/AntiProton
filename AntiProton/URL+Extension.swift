//
//  URL+Extension.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/12.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa
import ShellySwift

extension URL {
    var level: Int {
        return self.pathComponents.count
    }
    var fileIcon: NSImage {
        if self.isDirectory {
            let name = NSImage.folderName
            return NSImage(named: name)!
        } else {
            return NSWorkspace.shared.icon(forFileType: self.pathExtension)
        }
    }
    func levelComparedWith(_ baseURL: URL) -> Int { //
        return self.level - baseURL.level - 1
    }
    var isPlainTextFile: Bool {
        var result = false
        do {
            let _ = try String(contentsOf: self)
            result = true
        } catch {
        }
        return result
    }
}
