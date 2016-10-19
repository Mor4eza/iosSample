//
//  IndexHeader.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class IndexHeader: UITableViewHeaderFooterView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var lblIndex: UILabel!

    @IBOutlet weak var lblPercent: UILabel!
    @IBOutlet weak var lblCount: UILabel!
}
