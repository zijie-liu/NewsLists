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
    @IBOutlet weak var progressView: UIProgressView!
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
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "estimatedProgress":
            if webView.estimatedProgress < 1.0 {
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            } else {
                progressView.setProgress(1.0, animated: true)
                progressView.isHidden = true
            }
        default:
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func configure(urlString: String) {
        self.urlString = urlString
    }
}
