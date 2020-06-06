//
//  NewsAPIClient.swift
//  NewsList
//
//  Created by Peter on 6/4/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import Foundation

enum Enviroment {
    
    case headlines
    
    var baseURL: URL {
        switch self {
        case .headlines:
            return URL(string: "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=3e4aea0f28c14932b0f6955690c0d0a4")!
        }
    }
}

enum ResponseError: Error {
    case badResponseStatusCode(Int)
    case noResults
    case unableToConnect(Error)
    case unknown
}

protocol NewsService {
    func getHeadlines(with url: URL,
                      completion: @escaping (_ result: Result<HeadlinesResponse, Error>) -> Void ) -> Cancellable
}

class NewsAPIClient {
    static let shared: NewsAPIClient = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 5
        let session = URLSession(configuration: configuration)
        return NewsAPIClient(session: session)
    }()
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}

extension NewsAPIClient: NewsService {
    
    /// Creates a task that retrieve image from specified URL, then calls a handler
    /// - Parameters:
    ///   - url: The URL to be retrieved
    ///   - completion: The completion handler to call when the request is complete.
    ///   - result: The value associated with the response or error
    /// - Returns: a cancellable data task
    func getHeadlines(with url: URL, completion: @escaping (_ result: Result<HeadlinesResponse, Error>) -> Void) -> Cancellable {
        
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            
            let result: Result<HeadlinesResponse, Error>
            
            do {
                
                if let error = error as NSError?, error.code == NSURLErrorCannotConnectToHost {
                    throw ResponseError.unableToConnect(error)
                }
                
                guard let urlResponse = urlResponse as? HTTPURLResponse else {
                    throw error ?? ResponseError.unknown
                }
                
                guard (200 ..< 300).contains(urlResponse.statusCode) else {
                    throw ResponseError.badResponseStatusCode(urlResponse.statusCode)
                }
                
                let response = try JSONDecoder().decode(HeadlinesResponse.self, from: data ?? Data())
                
                guard response.totalResults ?? 0 > 0 else {
                    throw ResponseError.noResults
                }
                
                result = .success(response)
            } catch {
                result = .failure(error)
            }
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
        return task
    }
}
