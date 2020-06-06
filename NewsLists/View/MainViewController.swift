//
//  ViewController.swift
//  NewsLists
//
//  Created by Peter on 6/5/20.
//  Copyright © 2020 Jie Liu. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet private weak var newsSearchBar: UISearchBar!
    @IBOutlet private weak var newsCollectionView: UICollectionView!
    
    private let newsLoader: NewsLoader
    
    required init?(coder: NSCoder) {
        self.newsLoader = NewsLoader(service: NewsAPIClient.shared)
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsCollectionView.dataSource = self
        newsCollectionView.delegate = self
        newsSearchBar.delegate = self
        newsLoader.delegate = self
        newsCollectionView.collectionViewLayout = setupUICollectionViewLayout()
        newsLoader.loadNews()
    }
    
    private func setupUICollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 8)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: layoutSection)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsLoader.data?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.cell, for: indexPath) as? NewsCollectionViewCell,
            let article = newsLoader.data?[indexPath.row],
            let title = article.title,
            let author = article.author,
            let imageUrl = article.urlToImage
            else { return UICollectionViewCell() }
        
        cell.configure(title: title, author: author, imageUrl: imageUrl)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let article = newsLoader.data?[indexPath.row] else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailViewController = storyboard.instantiateViewController(identifier: DetailViewController.toString) as DetailViewController
        detailViewController.configure(with: article)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainViewController: NewsLoaderDelegate {
    func dataOnError(error: Error) {
        let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        alert.preferredAction = action
        present(alert, animated: true)
    }
    
    func dataChanged() {
        self.newsCollectionView.reloadData()
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            newsLoader.resetData()
        } else {
            newsLoader.filterData(with: searchText.lowercased())
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

