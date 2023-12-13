//
//  HistoryTableViewController.swift
//  NewsApp
//
//  Created by Ravi Gelani on 2023-12-10.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var userSearchHistory = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve existing user search history from UserDefaults
        if let existingHistory = UserDefaults.standard.array(forKey: "userHistory") as? [String] {
            userSearchHistory = existingHistory.reversed()
        }
    }
      
      override func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return userSearchHistory.count
     }
     
     
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          cell.textLabel?.text = userSearchHistory[indexPath.row]
         return cell
     }
}
