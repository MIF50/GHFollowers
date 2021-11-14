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
        self.viewControllers = [SearchVC.create(), FavoritesListVC.create()]
    }
}
