//
// Created by Mohamed Ibrahim on 28/06/2023.
//

import XCTest
@testable import GHFollowers

class GFTabBarControllerTests: XCTestCase {
    
    func test_viewDidLoad_tintColor() {
        let sut = makeSUT()

        XCTAssertEqual(UITabBar.appearance().tintColor, .systemGreen)
        XCTAssertEqual(sut.tabBar.tintColor, .systemGreen)
    }

    func test_viewDidLoad_firstSearchViewController() {
        let sut = makeSUT()
                
        guard let nav = sut.viewControllers?.first as? UINavigationController else {
            XCTFail("First ViewController should be of type UINavigationController")
            return
        }
        
        guard let _ = nav.topViewController as? SearchVC else {
            XCTFail("Root view controller should be of type SearchVC")
            return
        }
    }
    
    func test_viewDidLoad_searchTabBarItem() {
        let tabBar = makeSUT().viewControllers?.first?.tabBarItem
        
        XCTAssertEqual(tabBar?.tag, 0,"tab bar tag")
        XCTAssertEqual(tabBar?.image,tabBarSearchImage,"Tab bar item should have the 'search' system item type.")
    }
    
    func test_viewDidLoad_secondFavoritesListViewController() {
        let sut = makeSUT()
        
        guard let nav = sut.viewControllers?[1] as? UINavigationController else {
            XCTFail("First ViewController should be of type 'UINavigationController'")
            return
        }
        
        guard let _ = nav.topViewController as? FavoritesListVC else {
            XCTFail("Root view controller should be of type 'FavoritesListVC'")
            return
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> GFTabBarController {
        let vc = GFTabBarController()
        vc.loadViewIfNeeded()
        return vc
    }
    
    private var tabBarSearchImage: UIImage? {
        UITabBarItem(tabBarSystemItem: .search, tag: 0).image
    }

}
