//
//  Headlines.swift
//  NewsList
//
//  Created by Peter on 6/4/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import Foundation

struct HeadlinesResponse: Decodable {
    var status: String?
    var totalResults: Int?
    var articles: [Article?]
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
}

struct Article: Decodable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    private enum CodingKeys: String, CodingKey {
        case source, author, title
        case description, url, urlToImage
        case publishedAt, content
    }
}

struct Source: Decodable {
    var id: String?
    var name: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
