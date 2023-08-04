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
        client.get(from: url) { result in
            switch result {
            case let .success((data,response)):
                completion(FollowerMapper.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}

enum FollowerMapper {

    private struct Item: Decodable {
        let login: String
        let avatar_url: URL

        var item: FollowerViewData {
            FollowerViewData(login: login, url: avatar_url)
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) -> FollowerLoader.Result {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode([Item].self, from: data)
        else {
            return .failure(RemoteFollowerLoader.Error.invalidData)
        }
        let items = root.map { $0.item }
        return .success(items)
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
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index,code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                client.complete(withStatusCode: code, data: Data(),at: index)
            })
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJson = Data("invalid data".utf8)
            client.complete(withStatusCode: 200, data: invalidJson)
        })
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithPartiallyValidJSONItems() {
        let (sut, client) = makeSUT()
        
        let validItem = makeItem(login: "login-1", imageURL: URL(string: "https://url-1.com")!).json
        let invalidItem = ["invalid": "item"]
        let items = [validItem,invalidItem]
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let data = makeItemsJSON(items)
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: .success([]), when: {
            let data = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    func test_load_deliversSuccessWithItemsOn200HTTPResponseWithJSOnItems() {
        let (sut, client) = makeSUT()
        let item1 = makeItem(login: "login-1", imageURL: URL(string: "https://url-1.com")!)
        let item2 = makeItem(login: "login-2", imageURL: URL(string: "https://url-2.com")!)

        expect(sut, toCompleteWith: .success([item1.model,item2.model]), when: {
            let data = makeItemsJSON([item1.json,item2.json])
            client.complete(withStatusCode: 200, data: data)
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
    
    private func makeItem(login: String, imageURL: URL) -> (model: FollowerViewData, json: [String: Any]) {
        let item = FollowerViewData(login: login, url: imageURL)

        let json = [
            "login": login,
            "avatar_url": imageURL.absoluteString
        ].compactMapValues { $0 }

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}

