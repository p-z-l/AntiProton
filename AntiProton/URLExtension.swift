//
//  URLExtension.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/12.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

extension URL {
    var isDirectory: Bool {
        var result : ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &result)
        return result.boolValue
    }
    var isFile: Bool {
        var result : ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &result)
        return !result.boolValue
    }
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
    var subdirectoryURLs: [URL]? {
        guard self.isDirectory else { return nil}
        return DocumentManager.urlsInDirectory(self)
    }
}
