//
//  NewsCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/7/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var lblNewsTitle: UILabel!
    @IBOutlet weak var lblNewsDetails: UILabel!
    @IBOutlet weak var lblNewsDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblNewsTitle.setDefaultFont()
        lblNewsDetails.setDefaultFont()
        lblNewsDate.setDefaultFont()
        lblNewsTitle.changeDirection()
        lblNewsDetails.changeDirection()
        lblNewsDate.changeDirection()
        lblNewsTitle.font = lblNewsTitle.font.fontWithSize(14)
        lblNewsDetails.font = lblNewsDetails.font.fontWithSize(14)
        lblNewsDate.font = lblNewsDate.font.fontWithSize(14)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
