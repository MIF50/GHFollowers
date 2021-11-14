//
//  Helpers+Ext.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import Foundation


extension URL {
    static var anyURL: URL {
        return URL(string: "https://any-url.com")!
    }
}

extension NSError {
    static var anyNSError: NSError {
        return NSError(domain: "any error", code: 0)
    }
}

extension Data {
    static var anyData: Data {
        return Data("any data".utf8)
    }
}

