//
//  URLSessionHTTPClient.swift
//  GHFollowers
//
//  Created by MIF50 on 14/11/2021.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    
    private let session: URLSession
    
    public init(_ session: URLSession = .shared) {
        self.session = session
    }
    
    private struct UnExpectedValuesRepresentation: Error { }
    
    public func get(from url: URL,completion:@escaping ((HTTPClientResult)-> Void)) {
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let response = response as? HTTPURLResponse {
                completion(.success(data, response))
            } else {
                completion(.failure(UnExpectedValuesRepresentation()))
            }
            
        }.resume()
    }
}
