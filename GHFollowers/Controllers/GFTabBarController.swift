//
//  GFTabBarController.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/11/20.
//

import UIKit

class GFTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        tabBar.tintColor = .systemGreen
        
        viewControllers = [searchController(), FavoritesListVC.create()]
    }
    
    private func searchController() -> UINavigationController {
        let vc = SearchVC.create()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: vc)
    }
}
