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
    
    func test_viewDidLoad_favoriteTabBarItem() {
        let tab = tab(at: 1)
        
        XCTAssertEqual(tab.tagTabBar, tabBarFavorites.tag,"tab bar tag")
        XCTAssertEqual(tab.dataImageTabBar,tabBarFavorites.selectedImage?.pngData(),"Tab bar item should have the 'favorite' system item type.")
    }
    
    //MARK: - Helpers
    
    private func makeSUT() -> GFTabBarController {
        let vc = GFTabBarController()
        vc.loadViewIfNeeded()
        return vc
    }
    
    func tab(at index: Int) -> UIViewController {
        let sut = makeSUT()
        let tab = sut.viewControllers?[index] as! UINavigationController
        return tab.topViewController!
    }
    
    private var tabBarSearchImage: UIImage? {
        UITabBarItem(tabBarSystemItem: .search, tag: 0).image
    }
    
    private var tabBarFavorites: UITabBarItem {
        UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    }
}

private extension UIViewController {
    
    var tagTabBar: Int {
        tabBarItem.tag
    }
    
    var dataImageTabBar: Data? {
        tabBarItem.selectedImage?.pngData()
    }
}
