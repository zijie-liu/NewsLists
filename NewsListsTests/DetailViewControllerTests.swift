//
//  DetailedViewControllerTests.swift
//  NewsListsTests
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import XCTest
@testable import NewsLists

class DetailViewControllerTests: XCTestCase {
    
    private var detailViewController: DetailViewController!
    
    override func setUpWithError() throws {
        let article = Article(source: Source(id: "techcrunch",
                                             name: "TechCrunch"),
                              author: "Scott Orn, Bill Growney",
                              title: "15 things founders should know before accepting funding from a corporate VC",
                              description: "Here’s a list of the top 15 things every founder should know before signing a term sheet with a CVC.",
                              url: "https://techcrunch.com/2020/06/05/15-things-founders-should-know-before-accepting-funding-from-a-corporate-vc/",
                              urlToImage: "https://techcrunch.com/wp-content/uploads/2020/06/GettyImages-1204328192.jpg?w=600",
                              publishedAt: "2020-06-05T13:38:54Z",
                              content: "More posts by this contributor\r\nMore posts by this contributor\r\nMore than $50 billion of corporate venture capital (CVC) was deployed in 2018 and new data indicates that nearly half of all venture ro… [+7812 chars]")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        detailViewController = storyboard.instantiateViewController(identifier: DetailViewController.toString) as DetailViewController
        detailViewController.configure(with: article)
    }
    
    func testDetailViewController() {
        detailViewController.loadViewIfNeeded()
        XCTAssertNotNil(detailViewController)
    }

}
