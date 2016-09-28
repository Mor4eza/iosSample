//
//  SymbolCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class SymbolCell: UITableViewCell {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var lblLastTradeChanges: UILabel!
    @IBOutlet weak var lblLastTrade: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        lblAmount.setDefaultFont()
        lblVolume.setDefaultFont()
        lblLastTrade.setDefaultFont()
        lblLastTradeChanges.setDefaultFont()
        lblName.setDefaultFont()
        lblLastTradeChanges.layer.cornerRadius = 6
        lblLastTradeChanges.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
