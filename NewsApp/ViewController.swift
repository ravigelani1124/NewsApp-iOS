//
//  ViewController.swift
//  NewsApp
//
//  Created by Ravi Gelani on 2023-12-06.
//

import UIKit

class ViewController: UIViewController {

    private var articles: [Article]?

    override func viewDidLoad() {
        super.viewDidLoad()


        // Call searchNews to fetch news
        NetworkingManager.shared.searchNews(searchText: "canada") { [weak self] result in
            switch result {
            case .success(let articleList):
                // Update the articles array and refresh the table view on the main thread
                DispatchQueue.main.async {
                    self?.articles = articleList
                    print("NewsList \(articleList.count)")
                }

            case .failure(let error):
                // Handle the error appropriately
                print("Error: \(error)")
            }
        }
        
    }
}





