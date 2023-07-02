//
//  UIControllers+TestHelpers.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 02/07/2023.
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
