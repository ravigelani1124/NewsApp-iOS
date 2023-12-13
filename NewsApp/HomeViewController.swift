//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Ravi Gelani on 2023-12-08.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var searchView: UISearchBar!
  
    @IBOutlet weak var pickerView: UIPickerView!
  
    @IBOutlet weak var tableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView!

    private var articles: [Article] = []

    private var categoryList: [String] = ["Business","Entertainment","General","Health","Science","Sports","Technology"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        
        let nib = UINib(nibName: "NewsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        searchView.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        getSearchData(text:categoryList[0])
    }
    
   

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getSearchData(text:categoryList[row])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
    
  
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        cell.tvTitle?.text = articles[indexPath.row].title
        cell.tvAutherName?.text = articles[indexPath.row].author
        
        if(articles[indexPath.row].publishedAt != nil){
            let originalDateString = articles[indexPath.row].publishedAt
            let formattedDate = formatDate(originalDateString!)
            cell.tvPublishDate?.text = formattedDate
        }
        
        if(articles[indexPath.row].urlToImage != nil){
            if let imageURL = URL(string:  articles[indexPath.row].urlToImage!) {
                cell.ivImage.loadImage(url: imageURL)
            }
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ViewToDetails", sender: self)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.count <= 2){
            articles = [Article]()
            tableView.reloadData()
        }
        if (searchText.count > 2){
            getSearchData(text:searchText)
        }
        
        if(searchText.count == 0){
            getTopHeadlines()
        }
    }
    
    
    
    func getSearchData(text: String){
        
        if(text.count > 4){
            var userSearchHistory = [String]()
            // Retrieve existing user search history from UserDefaults
            if let existingHistory = UserDefaults.standard.array(forKey: "userHistory") as? [String] {
                userSearchHistory = existingHistory
            }
            // Check if searchText is not already present in userSearchHistory
            if !userSearchHistory.contains(text) {
                // Add the new search text to the history
                userSearchHistory.append(text)
                // Save the updated history back to UserDefaults
                UserDefaults.standard.set(userSearchHistory, forKey: "userHistory")
            }
            print(userSearchHistory.count)
        }        

        activityIndicator.startAnimating()
        NetworkingManager.shared.searchNews(searchText: text) { [weak self] result in
            switch result {
            case .success(let articleList):
                // Update the articles array and refresh the table view on the main thread
                DispatchQueue.main.async {
                    self?.articles = articleList
                    self?.tableView.reloadData()
                    print("NewsList \(articleList.count)")
                    self?.activityIndicator.stopAnimating()
                }

            case .failure(let error):
                // Handle the error appropriately
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
                print("Error: \(error)")
            }
        }
    }
    
    func getTopHeadlines(){
        NetworkingManager.shared.getTopHeadLinesNews(){
            [weak self] result in
                switch result {
                case .success(let articleList):
                    // Update the articles array and refresh the table view on the main thread
                    DispatchQueue.main.async {
                        self?.articles = articleList
                        self?.tableView.reloadData()
                        print("NewsList \(articleList.count)")
                    }
                case .failure(let error):
                    // Handle the error appropriately
                    print("Error: \(error)")
                }
        }
    }
    

    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        } else {
            // Return the original string if the date conversion fails
            return dateString
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        let detailsVC = segue.destination as! NewsDetailsViewController
//        let selectedRow = tableView.indexPathForSelectedRow!.row
//        detailsVC.aritcle = articles[selectedRow]
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewToDetails" {
                    let detailsVC = segue.destination as! NewsDetailsViewController
                    let selectedRow = tableView.indexPathForSelectedRow!.row
                    detailsVC.aritcle = articles[selectedRow]
        }
    }

}

extension UIImageView {
    func loadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
