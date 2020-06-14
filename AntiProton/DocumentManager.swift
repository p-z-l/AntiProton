//
//  DocumentManager.swift
//  AntiProton
//
//  Created by Peter Luo on 2020/6/9.
//  Copyright © 2020 Peter Luo. All rights reserved.
//

import Cocoa

class DocumentManager: NSObject {
    
    var baseURL : URL? {
        didSet {
            guard self.baseURL != nil else { return }
            openURL(baseURL!)
        }
    }
    
    private(set) var files = [File]() {
        didSet {
            dataChangeHandler()
        }
    }
    
    // called when the data is changed
    private var dataChangeHandler: ()->Void = {}
    func didChangeData(_ handler: @escaping ()->Void) {
        dataChangeHandler = handler
    }
    
    static func filesInDirectory(_ url: URL) -> [File] {
        var files = [File]()
        let options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles,
            .skipsPackageDescendants,
            .skipsSubdirectoryDescendants,
        ]
        guard let enumerator = FileManager.default.enumerator(at: url,includingPropertiesForKeys: nil, options: options) else { return [File]() }
        while let fileURL = enumerator.nextObject() as? URL {
            files.append(File(url: fileURL))
        }
        files.sort { $0.url.lastPathComponent < $1.url.lastPathComponent } // sort files A-z
        return files
    }
    
    private func openURL(_ url: URL) {
        files.removeAll()
        
        for file in DocumentManager.filesInDirectory(url) {
            files.append(file)
        }
    }
    
}

class File: NSObject {
    
    let url : URL
    
    init(url: URL) {
        self.url = url
    }
    
    var subDirectoryFiles : [File]? {
        guard url.isDirectory else { return nil }
        return DocumentManager.filesInDirectory(url)
    }
}

