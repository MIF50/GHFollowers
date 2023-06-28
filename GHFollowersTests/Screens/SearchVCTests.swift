//
// Created by Mohamed Ibrahim on 28/06/2023.
//

import XCTest
@testable import GHFollowers

class SearchVCTests: XCTestCase {

    func test_init_hasTitle() {
        XCTAssertNotNil(makeSUT().title,"Search")
    }

    // MARK:- Helpers
    private func makeSUT() -> SearchVC {
        let sut = SearchVC.create()
        sut.loadViewIfNeeded()
        return sut.topViewController as! SearchVC
    }
}
