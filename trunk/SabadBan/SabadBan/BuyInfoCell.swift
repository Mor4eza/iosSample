//
//  BuyInfoCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/17/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class BuyInfoCell: UITableViewCell {
    
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnDelete: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
