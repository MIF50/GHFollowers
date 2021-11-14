//
//  User.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import Foundation

public struct User: Codable {
    
    let login: String
    let avatarUrl: String
    var location: String?
    var name: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let htmlUrl: String
    let createdAt: Date
}
