//
//  SymbolListHeader.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class SymbolListHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblVolume: UILabel!

    @IBOutlet weak var lblLastTrade: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgSortName: UIImageView!
    @IBOutlet weak var imgSortAmount: UIImageView!
    @IBOutlet weak var imgSortVolume: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
