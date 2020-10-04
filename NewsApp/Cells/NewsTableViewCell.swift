//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Shantanu Tiwari on 23/09/20.
//  Copyright © 2020 Shantanu Tiwari. All rights reserved.
//

import UIKit
protocol NewsTableViewCellDelegate{
    func shareNews(url: String)
}
class NewsTableViewCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var newsimage:UIImageView!
    @IBOutlet weak var titlelabel:UILabel!
    @IBOutlet weak var descriptionlabel:UILabel!
    @IBOutlet weak var sharebtn:UIButton!
    @IBOutlet weak var readmorebtn:UIButton!
    @IBOutlet weak var date:UILabel!
    @IBOutlet weak var source:UILabel!
    @IBOutlet weak var innerimgview:UIView!
    var delagate: NewsTableViewCellDelegate?
    var newUrl = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.newsimage.layer.cornerRadius = 32
        self.newsimage.clipsToBounds = true
        
        self.innerimgview.layer.cornerRadius = 12
        self.innerimgview.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:- Actions
    @IBAction func sharebtnTapped(_ sender: UIButton) {
        self.delagate?.shareNews(url: newUrl)
    }
    
    @IBAction func readmorebtnTapped(_ sender: UIButton) {
        
    }
    
}
