//
// Created by Mohamed Ibrahim on 28/06/2023.
//

import XCTest
@testable import GHFollowers

class SearchVCTests: XCTestCase {

    func test_init_hasTitle() {
        XCTAssertNotNil(makeSUT().title,"Search")
    }
    
    func test_viewWillAppear_hideNavigationBar() {
        let sut = makeSUT()
        let nav = UINavigationController(rootViewController: sut)

        sut.viewWillAppear(false)
                
        XCTAssertEqual(nav.isNavigationBarHidden,true,"hide navigation bar")
    }
    
    func test_viewDidLoad_backgroundColor() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground,"view background color")
    }
    
    func test_viewDidLoad_subviews() {
        let sut = makeSUT()
        let sutSubViews = [sut.logoImageView,sut.userNameTextField,sut.getFollowersButton]
        XCTAssertEqual(sut.view.subviews, sutSubViews,"subviews")
    }
    
    func test_viewDidLoad_logoImageView_imageData() {
        let sut = makeSUT()
        XCTAssertEqual(sut.logoImageView.image?.pngData(), Images.ghLogo?.pngData(),"data logo image view")
    }
    
    func test_viewDidLoad_userNameTextField_delegate() {
        let sut = makeSUT()
        
        XCTAssertNotNil(sut.userNameTextField.delegate)
    }

    // MARK:- Helpers
    
    private func makeSUT() -> SearchVC {
        let sut = SearchVC.create()
        sut.loadViewIfNeeded()
        return sut
    }
}
