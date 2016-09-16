//
//  MarketDetailsCell.swift
//  SabadBan
//
//  Created by ehsan on 9/16/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class MarketDetailsCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblTitle.setDefaultFont()
        lblValue.setDefaultFont()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
