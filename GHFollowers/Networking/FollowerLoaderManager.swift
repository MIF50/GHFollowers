//
//  FollowerLoader.swift
//  GHFollowers
//
//  Created by Mohamed Ibrahim on 21/07/2023.
//

import UIKit

protocol URLSessionProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class FollowerLoaderManager {
        
    private let baseUrl = "https://api.github.com/users/"
        
    private let session: URLSessionProtocol

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadFollowers(for username: String, page: Int, completed: @escaping(Result<[Follower], GFError>) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let  url = URL(string: endpoint) else {
            completed(.failure(.invalidUserName))
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
        
            if error != nil {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
            
        }
        
        task.resume()
        
    }
}
