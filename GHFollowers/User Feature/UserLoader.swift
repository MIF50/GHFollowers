//
//  UserLoader.swift
//  GHFollowers
//
//  Created by MIF50 on 14/11/2021.
//

import Foundation

public enum LoadUserResult {
    case success(User)
    case failure(Error)
}

public protocol UserLoader {
    func load(completion: @escaping ((LoadUserResult) -> Void))
}
