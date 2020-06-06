//
//  NewsLoaderTests.swift
//  NewsListsTests
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import XCTest
@testable import NewsLists

class NewsLoaderTests: XCTestCase {
    private var testCount = 0
    private var newsLoader: NewsLoader?
    private let expectation = XCTestExpectation(description: "load headlines json stub")
    
    override func setUpWithError() throws {
        let service = MockAPIServiceClinet()
        service.onCompleted = { [weak self] in
            self?.expectation.fulfill()
        }
        newsLoader = NewsLoader(service: service)
        if let path = Bundle(for: type(of: self)).path(forResource: "HeadlineResponse", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            newsLoader?.loadNews(url: url)
        }
        
        newsLoader?.delegate = self
    }
    
    override func tearDownWithError() throws {
        newsLoader = nil
    }
    
    func testNewsLoader() {
        wait(for: [expectation], timeout: 15)
        XCTAssert(newsLoader?.data?.count ?? 0 == 10)
        XCTAssert(testCount == 1)
        newsLoader?.filterData(with: "things")
        XCTAssert(newsLoader?.data?.count ?? 0 == 1)
        newsLoader?.resetData()
        XCTAssert(newsLoader?.data?.count ?? 0 == 10)
        
    }
}

extension NewsLoaderTests: NewsLoaderDelegate {
    func dataChanged() {
        testCount += 1
    }
    
    func dataOnError(error: Error) {
        testCount -= 1
    }
}
