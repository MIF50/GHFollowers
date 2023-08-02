//
//  FollowerListVCTests.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 15/07/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import GHFollowers

final class FollowerListVCTests: XCTestCase {
    
    func test_viewDidLoad_shouldMakeDataTaskToSearchForMIF50() {
        let username = "MIF50"
        let (sut,session) = makeSUT(username: username)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(session.dataTaskCallCount, 1,"called once")
        XCTAssertEqual(session.dataTaskArgsUrl.last, URL(string: "https://api.github.com/users/MIF50/followers?per_page=100&page=1")!)
    }
    
    func test_getFollowers_withSuccessResponseShouldSaveDataInResult() {
        
        let (sut,session) = makeSUT()
        sut.loadViewIfNeeded()

        let exp = expectation(description: "wait for completion")
        sut.handleResult = { _ in
            exp.fulfill()
        }
        session.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),nil)
        wait(for: [exp], timeout: 1.0)

        XCTAssertEqual(sut.followers, [.init(login: "login-1", avatarUrl: "https://image-1.com")])
    }
    
    func test_getFollowers_withSuccessResponseBeforeAsyncShouldNotSaveDataInResult() {
        let (sut,session) = makeSUT()
        sut.loadViewIfNeeded()

        session.dataTaskArgsCompletionHandler.first?(jsonData(),response(statusCode: 200),nil)

        XCTAssertEqual(sut.followers, [])
    }
    
//    @MainActor
//    func test_getFollowers_withErrorShouldShowAlert() {
//        let presentationVerifier = PresentationVerifier()
//        let (sut,session) = makeSUT()
//        sut.loadViewIfNeeded()
//        
//        let exp = expectation(description: "wait for completion")
//        presentationVerifier.testCompletion  = {
//            exp.fulfill()
//        }
//
//        let error = NSError(domain: "any error", code: 0)
//        session.dataTaskArgsCompletionHandler.first?(nil,nil,error)
//        wait(for: [exp], timeout: 1.0)
//
//        guard let alert = presentationVerifier.verify(animated: true,presentingViewController: sut) as? GFAlertVC else {
//            XCTFail("Expected to get 'GFAlertVC' as presentation controller")
//            return
//        }
//        
//        XCTAssertEqual(alert.alertTitle, "Bad Stuff Happened")
//        XCTAssertEqual(alert.message, GFError.unableToComplete.rawValue)
//        XCTAssertEqual(alert.buttonTitle, "OK")
//    }
    
    @MainActor
    func test_getFollowers_withErrorBeforeAsyncShouldNotShowAlert() {
        let presentationVerifier = PresentationVerifier()
        let (sut,session) = makeSUT()
        sut.loadViewIfNeeded()
        
        let error = NSError(domain: "any error", code: 0)
        session.dataTaskArgsCompletionHandler.first?(nil,nil,error)
        
        XCTAssertEqual(presentationVerifier.presentedCount, 0)
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        username: String = "anyUsername"
    ) -> (sut: FollowerListVC,session: URLSessionSpy) {
        let sut = FollowerListVC(userName: username)
        let session = URLSessionSpy()
        sut.loader = FollowerLoaderSpy(session: session)
        return (sut, session)
    }
    
    private class FollowerLoaderSpy: FollowerLoader {}
    
    private func jsonData() -> Data {
        """
            [
                {
                    "login": "login-1",
                    "avatar_url": "https://image-1.com"
                }
            ]
        """.data(using: .utf8)!
    }

    
    
    private func response(statusCode: Int) -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://dummy.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
}

class URLSessionSpy: URLSessionProtocol {
    
    var dataTaskCallCount = 0
    var dataTaskArgsUrl = [URL]()
    var dataTaskArgsCompletionHandler: [((Data?, URLResponse?, Error?) -> Void)] = []
    
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        dataTaskCallCount += 1
        dataTaskArgsUrl.append(url)
        dataTaskArgsCompletionHandler.append(completionHandler)
        return FakeURLSessionDataTask()
    }
    
    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
}

