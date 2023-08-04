//
//  RemoteFollowerLoaderTests+Helpers.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 03/08/2023.
//

import XCTest
import GHFollowers

extension RemoteFollowerLoaderTests {
    
    func expect(
        _ sut: RemoteFollowerLoader,
        toCompleteWith expectedResult: Result<[FollowerViewData], RemoteFollowerLoader.Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError as RemoteFollowerLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
}
