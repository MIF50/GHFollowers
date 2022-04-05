//
//  RemoteUser.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 03/04/2022.
//

import Foundation

public struct RemoteUser: Codable {
    let login: String
    let avatar_url: String
    var location: String?
    var name: String?
    var bio: String?
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
    let html_url: String
    let created_at: Date
}
