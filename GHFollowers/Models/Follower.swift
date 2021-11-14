//
//  Follower.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 10/4/20.
//

import Foundation

struct Follower: Codable, Hashable {
    
    var login: String
    var avatarUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(login)
    }
    
}
