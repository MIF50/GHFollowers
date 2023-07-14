//
//  UITextField+XCTestCaseHelpers.swift
//  GHFollowersTests
//
//  Created by Mohamed Ibrahim on 14/07/2023.
//

import UIKit

@discardableResult
func shouldReturn(_ textField: UITextField) -> Bool? {
    textField.delegate?.textFieldShouldReturn?(textField)
}
