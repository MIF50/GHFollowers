//
//  FollowerListVCTests.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 15/07/2023.
//

import XCTest
@testable import GHFollowers

final class FollowerListVCTests: XCTestCase {
    
    func test_viewDidLoad_shouldMakeDataTaskToSearchForMIF50() {
        let username = "MIF50"
        let (sut,mockedSession) = makeSUT(username: username)
        
        sut.loadViewIfNeeded()
        
        mockedSession.verifyDataTask(with: URL(string: "https://api.github.com/users/MIF50/followers?per_page=100&page=1")!)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        username: String = "any username"
    ) -> (sut: FollowerListVC,mockedSession: MockURLSession) {
        let mockedSession = MockURLSession()
        let sut = FollowerListVC(userName: username)
        sut.loader = FollowerLoaderSpy(session: mockedSession)
        return (sut, mockedSession)
    }
    
    private class FollowerLoaderSpy: FollowerLoader {}
    
}

class MockURLSession: URLSessionProtocol {
    
    var dataTaskCallCount = 0
    var dataTaskArgsUrl = [URL]()
    
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsUrl.append(url)
        return FakeURLSessionDataTask()
    }
    
    func verifyDataTask(
        with url: URL,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard dataTaskWasCalledOnce(file: file,line: line) else { return }
        
        XCTAssertEqual(dataTaskCallCount,1, "call count",file: file,line: line)
        XCTAssertEqual(dataTaskArgsUrl.first,url, "url",file: file,line: line)
    }
    
    private func dataTaskWasCalledOnce(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        verifyMethodCalledOnce(
            methodName: "dataTask(with:completionHandler:)",
            callCount: dataTaskCallCount,
            describeArguments: "url: \(dataTaskArgsUrl)",
            file: file,
            line: line
        )
    }
    
    
    func verifyMethodCalledOnce(
        methodName: String,
        callCount: Int,
        describeArguments: @autoclosure () -> String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        if callCount == 0 {
            XCTFail("Wanted but not invoked: \(methodName)",file: file, line: line)
            return false
        }
        
        if callCount > 1 {
            XCTFail("Wanted 1 time but was called \(callCount) times. " + "\(methodName) with \(describeArguments())",file: file, line: line)
            return false
        }
        
        return true
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
}

