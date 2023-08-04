//
//  FollowerViewData.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 03/08/2023.
//

import Foundation

public struct FollowerViewData: Equatable {
    public let login: String
    public let url: URL
    
    public init(login: String, url: URL) {
        self.login = login
        self.url = url
    }
}
