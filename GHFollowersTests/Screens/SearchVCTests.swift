//
// Created by Mohamed Ibrahim on 28/06/2023.
//

import XCTest
import ViewControllerPresentationSpy
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
    
    @MainActor
    func test_tapGetFollowersWithEmptyUsername_showPrsentationAlert() {
        let presentationVerifier = PresentationVerifier()
        let sut = makeSUT()
        sut.emptyUsername()
        
        sut.simulateTapOnFollowers()
        
        guard let alert = presentationVerifier.verify(animated: true,presentingViewController: sut) as? GFAlertVC else {
            XCTFail("Expected to get 'GFAlertVC' as presentation controller")
            return
        }
        
        XCTAssertEqual(alert.alertTitle, "Empty Username")
        XCTAssertEqual(alert.message, "Please enter a username. We need to know who to look for 😊.")
        XCTAssertEqual(alert.buttonTitle, "OK")
    }
    
    func test_tapGetFollowersWithNotEmptyUsername_resignResponderUsernameField() {
        let sut = makeSUT()
        putInViewHierarchy(sut)

        sut.userNameTextField.becomeFirstResponder()
        sut.notEmptyUsername()
        XCTAssertEqual(sut.userNameTextField.isFirstResponder, true,"precondition")
        
        sut.simulateTapOnFollowers()
        XCTAssertEqual(sut.userNameTextField.isFirstResponder, false)
    }

    // MARK:- Helpers
    
    private func makeSUT() -> SearchVC {
        let sut = SearchVC.create()
        sut.loadViewIfNeeded()
        return sut
    }
}

private extension SearchVC {
    
    func simulateTapOnFollowers() {
        getFollowersButton.simulate(event: .touchUpInside)
    }
    
    func emptyUsername() {
        userNameTextField.text = ""
    }
    
    func notEmptyUsername(_ value: String = "any username") {
        userNameTextField.text = value
    }
}
