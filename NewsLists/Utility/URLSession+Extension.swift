//
//  URLSession+Extension.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import UIKit

extension URLSession {
    enum ImageTaskError: Error {
        case missingResponse(Error?)
        case missingData(URLResponse)
        case invalidData(Data, URLResponse)
    }
    
    /// Creates a task that retrieve image from specified URL, then calls a handler
    /// - Parameters:
    ///   - url: The URL to be retrieved
    ///   - completionHandler: The completion handler to call when the request is complete.
    ///   - result: The value associated with UIImage or Error
    /// - Returns: The new session data task
    func imageTask(with url: URL, completionHandler: @escaping (_ result: Result<UIImage, Error>) -> Void) -> URLSessionTask {
        
        return dataTask(with: url) { data, urlResponse, error in
            
            guard let urlResponse = urlResponse else {
                completionHandler(.failure(ImageTaskError.missingResponse(error)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(ImageTaskError.missingData(urlResponse)))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completionHandler(.failure(ImageTaskError.invalidData(data, urlResponse)))
                return
            }
            
            completionHandler(.success(image))
        }
    }
}

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
}
