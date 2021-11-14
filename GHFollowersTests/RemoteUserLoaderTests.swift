//
//  RemoteUserLoaderTests.swift
//  GHFollowersTests
//
//  Created by MIF50 on 14/11/2021.
//

import XCTest
import GHFollowers

class RemoteUserLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL,client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    func load(completoin: @escaping((LoadUserResult)-> Void)) {
        client.get(from: url) { result in
            
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
    
    // MARK: - Helper
    
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath,
                         line: UInt = #line)->(sut: RemoteUserLoader,client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteUserLoader(url: url,client: client)
        
        return (sut,client)
    }
    
    private class HTTPClientSpy: HTTPClient {
        
        private var messages = [(url: URL,completion: (HTTPClientResult)-> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping ((HTTPClientResult) -> Void)) {
            messages.append((url,completion))
        }
    }

}
