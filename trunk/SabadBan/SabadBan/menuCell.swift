//
//  menuCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/13/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class menuCell: UITableViewCell {

    @IBOutlet weak var imgMenu: UIImageView!
    
    @IBOutlet weak var lblMenuName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
