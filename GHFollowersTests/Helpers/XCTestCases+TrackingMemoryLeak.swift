//
//  XCTestCases+TrackingMemoryLeak.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//


import XCTest

extension XCTestCase {
    
    func trackForMemoryLeak(_ instance: AnyObject,
                                    file: StaticString = #filePath,
                                    line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance,"Instance should have been deallocated.potential memory leak.",file: file,line: line)
        }
    }
}
