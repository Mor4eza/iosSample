//
//  SymbolNamesCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/31/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class SymbolNamesCell: UITableViewCell {

    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblName.changeDirection()
        lblFullName.changeDirection()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
