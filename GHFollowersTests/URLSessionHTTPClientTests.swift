//
//  URLSessionHTTPClientTests.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import XCTest
@testable import GHFollowers

enum HTTPClientResult {
    case success(Data,HTTPURLResponse)
    case failure(Error)
}

protocol HTTPClient {
    func get(from url: URL,completion:@escaping ((HTTPClientResult)-> Void))
}

class URLSessionHTTPClient {
    
    let session: URLSession
    
    init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    func get(from url: URL,completion:@escaping ((HTTPClientResult)-> Void)) {
        session.dataTask(with: url) { _, _, error in
            
            if let error = error {
                completion(.failure(error))
            }
            
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequest()
    }
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequest()
    }
    
    
    
    func test_getFromURL_performsGETRequestWithURL() {
        let url = URL.anyURL
        
        let exp = expectation(description: "Waiting form observer request")
        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        makeSUT().get(from: url) { _ in }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnErrorClient() {
        let requestError = NSError.anyNSError
        
        let receivedError = resultErrorFor(data: nil, response: nil, error: requestError)
        
        XCTAssertEqual(receivedError?.domain, requestError.domain)
        XCTAssertEqual(receivedError?.code, requestError.code)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line)-> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        return sut
    }
    
    private func resultErrorFor(data: Data?,
                                response: URLResponse?,
                                error:NSError?,
                                file: StaticString = #filePath,
                                line: UInt = #line)-> NSError? {
        
        let result = resultFor(data: data, response: response, error: error)
        
        switch result {
        case let .failure(error as NSError):
            return error
        default:
            XCTFail("Expected failure got \(result) instead",file: file,line: line)
            return nil
        }
    }
    
    private func resultFor(data: Data?,
                           response: URLResponse?,
                           error:NSError?,
                           file: StaticString = #filePath,
                           line: UInt = #line) -> HTTPClientResult {
        URLProtocolStub.stub(data: data,response: response,error: error)
        let sut = makeSUT(file: file,line: line)
        
        var receivedResult: HTTPClientResult!
        let exp = expectation(description: "Wating for completion")
        sut.get(from: URL.anyURL) { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        return receivedResult
    }
    
    final class URLProtocolStub: URLProtocol {
        
        private static var requestObserver: ((URLRequest)-> Void)?
        private static var sub: Stub?
        
        
        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: NSError?
        }
        
        static func startInterceptingRequest() {
            URLProtocolStub.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocolStub.unregisterClass(URLProtocolStub.self)
            sub = nil
            requestObserver = nil
        }
        
        static func stub(data: Data?,response: URLResponse?,error: NSError?) {
            sub = Stub(data: data, response: response, error: error)
        }
        
        static func observeRequest(_ request:@escaping ((URLRequest)-> Void)) {
            requestObserver = request
        }
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            
            if let requestObserver = URLProtocolStub.requestObserver {
                client?.urlProtocolDidFinishLoading(self)
                return requestObserver(request)
            }
            
            if let error = URLProtocolStub.sub?.error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
            
        }
        
        override func stopLoading() { }
    }

}

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
