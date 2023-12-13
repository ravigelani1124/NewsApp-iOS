//
//  NewsDetailsViewController.swift
//  NewsApp
//
//  Created by Ravi Gelani on 2023-12-08.
//

import UIKit

class NewsDetailsViewController: UIViewController {

    var aritcle : Article? = nil
    
    @IBOutlet weak var tvPublishDate: UILabel!
    @IBOutlet weak var tvAuthorName: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tvDesc: UITextView!
    
    @IBAction func btnOpenWebPage(_ sender: Any) {
    

        if(aritcle?.url != nil){
            if let url = URL(string: (aritcle?.url!)!), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Invalid URL or unable to open URL")
            }
        }
    }
    
    @IBOutlet weak var tvTitle: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(aritcle != nil){
            tvAuthorName.text = aritcle?.author
            tvDesc.text = aritcle?.description
            tvTitle.text = aritcle?.title
            
            if(aritcle?.publishedAt != nil){
                let formattedDate = formatDate((aritcle?.publishedAt)!)
                tvPublishDate.text = formattedDate
            }
            
            if(aritcle?.urlToImage != nil){
                if let imageURL = URL(string: (aritcle?.urlToImage)!) {
                    ivImage.loadImage(url: imageURL)
                }
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
    

}

