//
//  SharedTestHelpers.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 02/07/2023.
//

import UIKit

func putInViewHierarchy(_ vc: UIViewController) {
    let window = UIWindow()
    window.addSubview(vc.view)
}

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
