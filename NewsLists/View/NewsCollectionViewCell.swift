//
//  NewsCollectionViewCell.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import UIKit

final class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    
    func configure(title: String, author: String, imageUrl: String) {
        titleLabel.text = title
        authorLabel.text = author
        guard let url = URL(string: imageUrl) else { return }
        let task = URLSession.shared.imageTask(with: url) {[weak self] (result) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                do {
                    self.backgroundImageView.image = try result.get()
                } catch {
                    debugPrint(error)
                }
            }
        }
        task.resume()
    }
}
