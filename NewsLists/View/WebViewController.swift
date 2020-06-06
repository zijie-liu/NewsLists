//
//  WebViewController.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet private weak var webView: WKWebView!
    private var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    private func setupWebView() {
        webView.navigationDelegate = self
        webView.backgroundColor = .systemBackground
        if let urlString = urlString,
            let url = URL(string: urlString) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
    
    func configure(urlString: String) {
        self.urlString = urlString
    }
}
