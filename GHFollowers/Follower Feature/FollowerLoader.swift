//
//  FollowerLoader.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 03/08/2023.
//

import Foundation

public protocol FollowerLoader {
    typealias Result = Swift.Result<[FollowerViewData], Error>

    func load(completion: @escaping (Result) -> Void)
}
