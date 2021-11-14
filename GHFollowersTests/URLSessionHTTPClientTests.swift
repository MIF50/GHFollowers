//
//  URLSessionHTTPClientTests.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import XCTest

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
        session.dataTask(with: url) { _, _, _ in
            
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
    
    // MARK: - Helper
    
    private func makeSUT()-> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        return sut
    }
    
    final class URLProtocolStub: URLProtocol {
        
        private static var requestObserver: ((URLRequest)-> Void)?
        
        
        static func startInterceptingRequest() {
            URLProtocolStub.registerClass(URLProtocolStub.self)
        }
        
        static func stopInterceptingRequest() {
            URLProtocolStub.unregisterClass(URLProtocolStub.self)
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
