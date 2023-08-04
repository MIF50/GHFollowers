//
//  RemoteFollowerLoaderTests.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 03/08/2023.
//

import XCTest
import GHFollowers

class RemoteFollowerLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
        
    func load(completion: @escaping ((FollowerLoader.Result) -> Void)) {
        client.get(from: url) { _ in
            completion(.failure(Error.connectivity))
        }
    }
    
    public enum Error: Swift.Error {
        case connectivity
    }
}

final class RemoteFollowerLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    //MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
                         file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteFollowerLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFollowerLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
}

