//
//  NewsLoader.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import Foundation

protocol NewsLoaderDelegate: AnyObject {
    func dataChanged()
    func dataOnError(error: Error)
}

class NewsLoader {
    
    private let service: NewsService
    private var response: HeadlinesResponse?
    private(set) var data: [Article?]? {
        didSet {
            delegate?.dataChanged()
        }
    }
    
    weak var delegate: NewsLoaderDelegate?
    
    init(service: NewsService) {
        self.service = service
    }
    
    func loadNews(url: URL = Enviroment.headlines.baseURL) {
        let _ = service.getHeadlines(with: url) { [weak self] (result) in
            guard let self = self else { return }
            do {
                self.response = try result.get()
                self.data = self.response?.articles
            } catch {
                self.delegate?.dataOnError(error: error)
            }
        }
    }
    
    /// Reset articles data with response
    func resetData() {
        data = response?.articles
    }
    
    /// Filter data and assign new data source
    /// - Parameter searchText: The search text to filter the article
    func filterData(with searchText: String) {
        data = response?.articles.filter({ (article) -> Bool in
            [article?.title, article?.description, article?.content].compactMap{
                $0?.lowercased().contains(searchText) }.contains(true)
        })
    }
}
