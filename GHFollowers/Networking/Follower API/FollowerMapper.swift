//
//  FollowerMapper.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 07/08/2023.
//

import Foundation

enum FollowerMapper {

    private struct Item: Decodable {
        let login: String
        let avatar_url: URL

        var item: FollowerViewData {
            FollowerViewData(login: login, url: avatar_url)
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) -> FollowerLoader.Result {
        guard response.statusCode == 200,
              let root = try? JSONDecoder().decode([Item].self, from: data)
        else {
            return .failure(RemoteFollowerLoader.Error.invalidData)
        }
        let items = root.map { $0.item }
        return .success(items)
    }
}
