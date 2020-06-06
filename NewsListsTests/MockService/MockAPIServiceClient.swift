//
//  MockAPIServiceClient.swift
//  NewsListsTests
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import Foundation
import XCTest
@testable import NewsLists

class MockAPIServiceClinet: NewsService {
    
    var onCompleted: (() -> Void)?
    
    func getHeadlines(with url: URL, completion: @escaping (Result<HeadlinesResponse, Error>) -> Void) -> Cancellable {
        
        let task = URLSession.shared.dataTask(with: url) {[weak self] (data, urlResponse, error) in
            guard let self = self else { return }
            let result: Result<HeadlinesResponse, Error>
            
            do {
                
                if let error = error as NSError?, error.code == NSURLErrorCannotConnectToHost {
                    throw ResponseError.unableToConnect(error)
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
                self.onCompleted?()
            }
            
        }
        
        task.resume()
        return task
    }
}

