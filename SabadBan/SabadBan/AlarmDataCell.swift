//
//  AlarmDataCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class AlarmDataCell: UITableViewCell {
    
    //MARK : - Properties

    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblType: UILabel!

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnEdit: UIButton!

    @IBOutlet weak var btnDelete: UIButton!
    
    @IBOutlet weak var backgroundLayer: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
