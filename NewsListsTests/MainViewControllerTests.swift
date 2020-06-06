//
//  MainViewControllerTests.swift
//  NewsListsTests
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import XCTest
@testable import NewsLists

class MainViewControllerTests: XCTestCase {
    private var mainViewController: MainViewController!
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = storyboard.instantiateViewController(identifier: MainViewController.toString) as MainViewController
    }
    
    func testCollectionViewExisted() throws {
        mainViewController.loadViewIfNeeded()
        XCTAssertNotNil(mainViewController)
    }
}
