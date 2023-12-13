//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Ravi Gelani on 2023-12-08.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var tvTitle: UILabel!
    @IBOutlet weak var tvPublishDate: UILabel!
    @IBOutlet weak var tvAutherName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
