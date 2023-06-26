//
//  RemoteUserLoaderTests.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import XCTest
import GHFollowers

class RemoteUserLoader {
    
    typealias Result = LoadUserResult
    
    enum Error: Swift.Error {
        case connectiviy
        case invalidData
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL,client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completoin: @escaping((Result)-> Void)) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                if response.statusCode == 200, let _ = try? JSONSerialization.jsonObject(with: data) {
                    completoin(.success(nil))
                } else {
                    completoin(.failure(Error.invalidData))
                }
            case .failure:
                completoin(.failure(Error.connectiviy))
            }
        }
    }
}

class RemoteUserLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_,client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL.anyURL
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL.anyURL
        let (sut,client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load{ _ in }
        
        XCTAssertEqual(client.requestedURLs, [url,url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompletWith: failure(.connectiviy),when: {
            let clientError = NSError.anyNSError
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [150,199,201,300,400,500]
        samples.enumerated().forEach { index,code in
            expect(sut, toCompletWith: failure(.invalidData), when: {
                let json = makeItemJSON([])
                client.complete(withStatusCode: code,data: json,at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJson() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompletWith: failure(.invalidData), when: {
            let invalidData = Data("invalid data".utf8)
            client.complete(withStatusCode: 200, data: invalidData)
        })
    }

    
    // MARK: - Helper
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath,
                         line: UInt = #line)->(sut: RemoteUserLoader,client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteUserLoader(url: url,client: client)
        trackForMemoryLeak(client,file: file,line: line)
        trackForMemoryLeak(sut,file: file,line: line)
        return (sut,client)
    }
    
    private func expect(
        _ sut: RemoteUserLoader,
        toCompletWith expectedResult: RemoteUserLoader.Result,
        when action: (()-> Void),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "waiting for Completion")
        
        sut.load { receivedResult in
            switch (receivedResult,expectedResult) {
            case let (.failure(receivedError as NSError),.failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError,file: file,line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead",file: file,line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failure(_ error: RemoteUserLoader.Error)-> RemoteUserLoader.Result {
        .failure(error)
    }
    
    private func makeItemJSON(_ items: [[String: Any]])-> Data {
//        let json = ["items": items]
        return try! JSONSerialization.data(withJSONObject: items)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL,completion: (HTTPClientResult)-> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void)) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error,at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int,data: Data,at index: Int = 0) {
            let response = HTTPURLResponse(url: requestedURLs[index], statusCode: code, httpVersion: nil, headerFields: nil)!
            messages[index].completion(.success(data, response))
        }
    }

}
