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
            guard baseURL != nil else { return }
            openURL(baseURL!)
        }
    }
    
    private(set) var fileURLs = [URL]() {
        didSet {
            dataChangeHandler()
        }
    }
    
    // called when the data is changed
    private var dataChangeHandler: ()->Void = {}
    func didChangeData(_ handler: @escaping ()->Void) {
        dataChangeHandler = handler
    }
    
    private func openURL(_ url: URL) {
        fileURLs.removeAll()
        var urls = [URL]()
        let options: FileManager.DirectoryEnumerationOptions = [
            .skipsHiddenFiles,
            .skipsPackageDescendants,
        ]
        guard let enumerator = FileManager.default.enumerator(at: url,includingPropertiesForKeys: nil, options: options) else { return }
        while let fileURL = enumerator.nextObject() as? URL {
            urls.append(fileURL)
        }
        // sort files A-z
        urls.sort { $0.path < $1.path }
        fileURLs = urls
    }
}
