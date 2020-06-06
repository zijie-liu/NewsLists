//
//  DetailedViewController.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var linkButton: UIButton!
    
    private var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        titleLabel.text = article?.title
        descriptionLabel.text = article?.description
        sourceLabel.text = article?.source?.name
        authorLabel.text = article?.author
        timeLabel.text = article?.publishedAt
        contentLabel.text = article?.content
        linkButton.setTitle(article?.url, for: .normal)
        
        guard
            let urlToIamge = article?.urlToImage,
            let url = URL(string: urlToIamge)
            else { return }
        
        let task = URLSession.shared.imageTask(with: url) { [weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                do {
                    self.imageView.image = try result.get()
                } catch {
                    debugPrint(error)
                }
            }
        }
        
        task.resume()
    }
    
    func configure(with article: Article) {
        self.article = article
    }
    
    @IBAction private func tappedOnLinkButton(_ sender: UIButton) {
        guard let urlString = article?.url else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let webViewController = storyboard.instantiateViewController(identifier: WebViewController.toString) as WebViewController
        webViewController.configure(urlString: urlString)
        navigationController?.pushViewController(webViewController, animated: true)
    }
}
