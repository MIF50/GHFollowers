//
//  URLSessionHTTPClientTests.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import XCTest
import GHFollowers

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
    
    func test_getFromURL_failsOnAllInvalidRepresentationCases() {
        let anyError = NSError.anyNSError
        let anyData = Data.anyData
        
        XCTAssertNotNil(resultErrorFor(data: nil,response: nil,error: nil))
        XCTAssertNotNil(resultErrorFor(data: nil, response: nonHTTPURLResponse(), error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData,response: nil, error: nil))
        XCTAssertNotNil(resultErrorFor(data: anyData,response: nil, error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil,response: nonHTTPURLResponse(), error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil,response: anyHTTPURLResponse(), error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData,response: nonHTTPURLResponse(), error: anyError))
        XCTAssertNotNil(resultErrorFor(data: anyData,response: anyHTTPURLResponse(), error: anyError))
        XCTAssertNotNil(resultErrorFor(data: nil,response: nonHTTPURLResponse(), error: nil))
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() {
        let data = Data.anyData
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: data,response: response,error: nil)
        
        XCTAssertEqual(receivedValues?.data, data)
        XCTAssertEqual(receivedValues?.response.url, response?.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response?.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPResponseWithNilData() {
        let response = anyHTTPURLResponse()
        
        let receivedValues = resultValuesFor(data: nil, response: response, error: nil)
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url,response?.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response?.statusCode)
    }
    
    // MARK: - Helper
    
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line)-> HTTPClient {
        let sut = URLSessionHTTPClient()
        return sut
    }
    
    private func resultValuesFor(data: Data?,
                                 response: URLResponse?,
                                 error:NSError?,
                                 file: StaticString = #filePath,
                                 line: UInt = #line)-> (data: Data,response: HTTPURLResponse)? {
        
        let result = resultFor(data: data, response: response, error: error,file: file,line: line)
        
        switch result {
        case let .success(data,response):
            return (data,response)
        default:
            XCTFail("Expected success got \(result) instead",file: file,line: line)
            return nil
        }
        
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
    
    func nonHTTPURLResponse()-> URLResponse {
        return URLResponse(url: URL.anyURL, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
    
    func anyHTTPURLResponse()-> HTTPURLResponse? {
        return HTTPURLResponse(url: URL.anyURL, statusCode: 200, httpVersion: nil, headerFields: nil)
    }
}
