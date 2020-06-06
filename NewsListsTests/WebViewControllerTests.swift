//
//  WebViewControllerTests.swift
//  NewsListsTests
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import XCTest
@testable import NewsLists

class WebViewControllerTests: XCTestCase {
    
    private var webViewController: WebViewController!
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        webViewController = storyboard.instantiateViewController(identifier: WebViewController.toString) as WebViewController
        webViewController.configure(urlString: "https://techcrunch.com/2020/06/05/15-things-founders-should-know-before-accepting-funding-from-a-corporate-vc/")
    }
    
    func testWebViewExisted() throws {
        webViewController.loadViewIfNeeded()
        XCTAssertNotNil(webViewController)
    }
}
