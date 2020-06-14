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
    
    private(set) var urls = [URL]() {
        didSet {
            dataChangeHandler()
        }
    }
    
    // called when the data is changed
    private var dataChangeHandler: ()->Void = {}
    func didChangeData(_ handler: @escaping ()->Void) {
        dataChangeHandler = handler
    }
    
    static func urlsInDirectory(_ url: URL) -> [URL] {
        var urls = [URL]()
        let options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles,
            .skipsPackageDescendants,
            .skipsSubdirectoryDescendants,
        ]
        guard let enumerator = FileManager.default.enumerator(at: url,includingPropertiesForKeys: nil, options: options) else { return [URL]() }
        while let fileURL = enumerator.nextObject() as? URL {
            urls.append(fileURL)
        }
        urls.sort { $0.lastPathComponent < $1.lastPathComponent } // sort URLs A-z
        return urls
    }
    
    private func openURL(_ url: URL) {
        urls.removeAll()
        
        for url in DocumentManager.urlsInDirectory(url) {
            urls.append(url) 
        }
    }
    
}
