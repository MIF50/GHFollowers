//
//  RemoteUser.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 03/04/2022.
//

import Foundation

public struct RemoteUser: Codable {
    public let login: String
    public let avatar_url: String
    public var location: String?
    public var name: String?
    public var bio: String?
    public let public_repos: Int
    public let public_gists: Int
    public let followers: Int
    public let following: Int
    public let html_url: String
    public let created_at: Date
}
