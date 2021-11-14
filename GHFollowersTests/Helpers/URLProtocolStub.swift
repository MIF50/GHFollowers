//
//  URLProtocolStub.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import Foundation

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
        
        if let response = URLProtocolStub.sub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let data = URLProtocolStub.sub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
        
    }
    
    override func stopLoading() { }
}
