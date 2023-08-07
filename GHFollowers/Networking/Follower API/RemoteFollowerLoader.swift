//
//  RemoteFollowerLoader.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 07/08/2023.
//

import Foundation

public final class RemoteFollowerLoader {
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
        
   public func load(completion: @escaping ((FollowerLoader.Result) -> Void)) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }

            switch result {
            case let .success((data,response)):
                completion(FollowerMapper.map(data, from: response))
                
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
}
