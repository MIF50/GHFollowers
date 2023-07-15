//
// Created by Mohamed Ibrahim on 28/06/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import GHFollowers

class SearchVCTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        executeRunLoop()
    }

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
    
    @MainActor
    func test_tapGetFollowers_withEmptyUsername_showPrsentationAlert() {
        let presentationVerifier = PresentationVerifier()
        let sut = makeSUT()
        
        sut.simulateTapOnFollowers()
        
        guard let alert = presentationVerifier.verify(animated: true,presentingViewController: sut) as? GFAlertVC else {
            XCTFail("Expected to get 'GFAlertVC' as presentation controller")
            return
        }
        
        XCTAssertEqual(alert.alertTitle, "Empty Username")
        XCTAssertEqual(alert.message, "Please enter a username. We need to know who to look for 😊.")
        XCTAssertEqual(alert.buttonTitle, "OK")
    }
    
    func test_tapGetFollowers_withEmptyUsername_shouldNotResignResponderUsernameField() {
        let sut = makeSUT()
        putInViewHierarchy(sut)

        sut.simulateUsernameFirstResponder()
        XCTAssertEqual(sut.usernameIsFirstReponder, true,"precondition")

        sut.simulateTapOnFollowers()
        XCTAssertEqual(sut.usernameIsFirstReponder, true)
    }
    
    func test_tapGetFollowers_withEmptyUsername_shouldNotPushFollowerList() {
        let sut = makeSUT()
        _ = SpyNavigationController(rootViewController: sut)

        sut.simulateTapOnFollowers()
        
        XCTAssertEqual(sut.navigationStackCount, 1,"navigation stack")
    }
    
    func test_shouldReturn_withEmptyUsername_shouldNotResignResponderUsernameField() {
        let sut = makeSUT()
        putInViewHierarchy(sut)

        sut.simulateUsernameFirstResponder()
        XCTAssertEqual(sut.usernameIsFirstReponder, true,"precondition")

        sut.simulateShouldReturnUsernameTextField()
        XCTAssertEqual(sut.usernameIsFirstReponder, true)
    }
    
    func test_shouldRetrun_withEmptyUsername_shouldNotPushFollowerList() {
        let sut = makeSUT()
        _ = SpyNavigationController(rootViewController: sut)

        sut.simulateShouldReturnUsernameTextField()
        
        XCTAssertEqual(sut.navigationStackCount, 1,"navigation stack")
    }
    
    func test_tapGetFollowers_withNotEmptyUsername_resignResponderUsernameField() {
        let sut = makeSUT(username: "any username")
        putInViewHierarchy(sut)

        sut.simulateUsernameFirstResponder()
        XCTAssertEqual(sut.usernameIsFirstReponder, true,"precondition")
        
        sut.simulateTapOnFollowers()
        XCTAssertEqual(sut.usernameIsFirstReponder, false)
    }
    
    func test_tappingGetFollowers_withNotEmptyUsername_shouldPushFollowerList() {
        let expectedUsername = "mohamed"
        let sut = makeSUT(username: expectedUsername)
        let navSpy = SpyNavigationController(rootViewController: sut)
                
        sut.simulateTapOnFollowers()
        
        assertPushFollower(sut, in: navSpy, with: expectedUsername)
    }
    
    @MainActor
    func test_shouldReturnTextField_withEmptyUsername_showPrsentationAlert() {
        let presentationVerifier = PresentationVerifier()
        let sut = makeSUT()
        
        sut.simulateShouldReturnUsernameTextField()
        
        guard let alert = presentationVerifier.verify(animated: true,presentingViewController: sut) as? GFAlertVC else {
            XCTFail("Expected to get 'GFAlertVC' as presentation controller")
            return
        }
        
        XCTAssertEqual(alert.alertTitle, "Empty Username")
        XCTAssertEqual(alert.message, "Please enter a username. We need to know who to look for 😊.")
        XCTAssertEqual(alert.buttonTitle, "OK")
    }
    
    func test_shouldReturnTextField_withNotEmptyUsername_resignResponderUsernameField() {
        let sut = makeSUT(username: "any username")
        putInViewHierarchy(sut)

        sut.simulateUsernameFirstResponder()
        XCTAssertEqual(sut.usernameIsFirstReponder, true,"precondition")

        sut.simulateShouldReturnUsernameTextField()
        XCTAssertEqual(sut.usernameIsFirstReponder, false)
    }

    func test_shouldReturnTextField_withNotEmptyUsername_shouldPushFollowerList() {
        let expectedUsername = "mohamed"
        let sut = makeSUT(username: expectedUsername)
        let navSpy = SpyNavigationController(rootViewController: sut)

        sut.simulateShouldReturnUsernameTextField()
        
        assertPushFollower(sut, in: navSpy, with: expectedUsername)
    }

    // MARK:- Helpers
    
    private func makeSUT(username: String = "") -> SearchVC {
        let sut = SearchVC.create()
        sut.userNameTextField.text = username
        sut.loadViewIfNeeded()
        return sut
    }
    
    func assertPushFollower(
        _ sut: SearchVC,
        in nav: SpyNavigationController,
        with expectedUsername: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertNotNil(sut.navigationController,file: file,line: line)


        XCTAssertEqual(nav.pushViewControllerArgsAnimated.last, false,file: file,line: line)
        XCTAssertEqual(sut.navigationStackCount, 2,"navigation stack",file: file,line: line)

        let pushedVC = sut.lastViewController
        guard let follwerListVC = pushedVC as? FollowerListVC else {
            XCTFail("Expected FollowerListVC, but was \(String(describing: pushedVC))",file: file,line: line)
            return
        }
        
        XCTAssertEqual(follwerListVC.userName, expectedUsername,file: file,line: line)
    }
    
    class SpyNavigationController: UINavigationController {
        
        private(set) var pushViewControllerArgsAnimated: [Bool] = []
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            super.pushViewController(viewController, animated: animated)
            pushViewControllerArgsAnimated.append(animated)
        }
        
    }
}

private extension SearchVC {
    
    var usernameIsFirstReponder: Bool {
        userNameTextField.isFirstResponder
    }
    
    func simulateUsernameFirstResponder() {
        userNameTextField.becomeFirstResponder()
    }
    
    func simulateShouldReturnUsernameTextField() {
        shouldReturn(userNameTextField)
    }
    
    func simulateTapOnFollowers() {
        getFollowersButton.simulate(event: .touchUpInside)
    }
    
    var navigationStackCount: Int? {
        navigationController?.viewControllers.count
    }
    
    var lastViewController: UIViewController? {
        navigationController?.viewControllers.last
    }
}
