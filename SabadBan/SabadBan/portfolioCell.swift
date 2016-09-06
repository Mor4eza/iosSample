//
//  portfolioCell.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/3/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class portfolioCell: UITableViewCell {
    
    
    @IBOutlet weak var lblsymbolTitle: UILabel!
    
    @IBOutlet weak var lblSymbolValue: UILabel!
    
    @IBOutlet weak var lblLastValueTitle: UILabel!
    
    @IBOutlet weak var lblLastPriceValue: UILabel!
    
    @IBOutlet weak var lblBuyQuotTitle: UILabel!
    
    @IBOutlet weak var lblBuyQuotValue: UILabel!
    
    @IBOutlet weak var lblOverTitle: UILabel!
    
    @IBOutlet weak var lblOverValue: UILabel!
    
    @IBOutlet weak var lblEndTitle: UILabel!
    @IBOutlet weak var lblEndValue: UILabel!
    
    @IBOutlet weak var lblEndChanges: UILabel!
    @IBOutlet weak var lblSellQuotTitle: UILabel!

    @IBOutlet weak var lblSellQuotValue: UILabel!
    
    @IBOutlet weak var lblTodayValue: UILabel!
    
    @IBOutlet weak var lblTodayTitle: UILabel!
    
    @IBOutlet weak var viewStatus: UIView!
    
    
    @IBOutlet weak var lblStatusTitle: UILabel!
    
    @IBOutlet weak var lblStatusValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblsymbolTitle.setDefaultFont()
        lblSymbolValue.setDefaultFont()
        lblLastValueTitle.setDefaultFont()
        lblLastPriceValue.setDefaultFont()
        lblBuyQuotTitle.setDefaultFont()
        lblBuyQuotValue.setDefaultFont()
        lblOverTitle.setDefaultFont()
        lblOverValue.setDefaultFont()
        lblEndTitle.setDefaultFont()
        lblEndValue.setDefaultFont()
        lblEndChanges.setDefaultFont()
        lblSellQuotValue.setDefaultFont()
        lblSellQuotTitle.setDefaultFont()
        lblTodayValue.setDefaultFont()
        lblTodayTitle.setDefaultFont()
        lblStatusTitle.setDefaultFont()
        lblStatusValue.setDefaultFont()
        
        viewStatus.layer.cornerRadius = 6
        viewStatus.layer.masksToBounds = true
        
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
