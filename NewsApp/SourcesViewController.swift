//
//  SourcesViewController.swift
//  NewsApp
//
//  Created by Ravi Gelani on 2023-12-08.
//

import UIKit

class SourcesViewController: UITableViewController {

    private var sources: [Source] = []
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        getSources()
    }
    
    func getSources(){
        activityIndicator.startAnimating()
        NetworkingManager.shared.getSources(){
            [weak self] result in
                switch result {
                case .success(let sourceList):
                    // Update the articles array and refresh the table view on the main thread
                    DispatchQueue.main.async {
                        self?.sources = sourceList
                        self?.tableView.reloadData()
                        self?.activityIndicator.stopAnimating()
                        print("sourceList \(sourceList.count)")
                    }
                case .failure(let error):
                    // Handle the error appropriately
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                }
        }
    }
    
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let url = URL(string: sources[indexPath.row].url!), UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
          print("Invalid URL or unable to open URL")
      }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return sources.count
   }
   
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = sources[indexPath.row].name
        cell.detailTextLabel?.text = sources[indexPath.row].description
       return cell
   }
}

