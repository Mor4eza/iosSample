//
//  IndexCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class IndexCell: UITableViewCell {

    
    @IBOutlet weak var imgIndex: UIImageView!
    @IBOutlet weak var lblIndexCount: UILabel!
    
    @IBOutlet weak var lblIndexPercent: UILabel!
    @IBOutlet weak var lblIndexName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    
        lblIndexCount.setDefaultFont()
        lblIndexPercent.setDefaultFont()
        lblIndexName.setDefaultFont()
        lblIndexCount.layer.cornerRadius = 6
        lblIndexCount.clipsToBounds = true
        lblIndexPercent.layer.cornerRadius = 6
        lblIndexPercent.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
