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
    
    @IBOutlet weak var imgChanges: UIImageView!
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
        
        
        //        self.contentView.transform = CGAffineTransformMakeScale(-1, 1)
        
        let fontSize = CGFloat(12)
        
        lblsymbolTitle.setDefaultFont(fontSize)
        lblSymbolValue.setDefaultFont(fontSize)
        lblLastValueTitle.setDefaultFont(fontSize)
        lblLastPriceValue.setDefaultFont(fontSize)
        lblBuyQuotTitle.setDefaultFont(fontSize)
        lblBuyQuotValue.setDefaultFont(fontSize)
        lblOverTitle.setDefaultFont(fontSize)
        lblOverValue.setDefaultFont(fontSize)
        lblEndTitle.setDefaultFont(fontSize)
        lblEndValue.setDefaultFont(fontSize)
        lblEndChanges.setDefaultFont(fontSize)
        lblSellQuotValue.setDefaultFont(fontSize)
        lblSellQuotTitle.setDefaultFont(fontSize)
        lblTodayValue.setDefaultFont(fontSize)
        lblTodayTitle.setDefaultFont(fontSize)
        lblStatusTitle.setDefaultFont(fontSize)
        lblStatusValue.setDefaultFont(fontSize)
        
        viewStatus.layer.cornerRadius = 6
        viewStatus.layer.masksToBounds = true
        
        // Initialization code
    }
    
    func initCells(smData: symData) {
        
        lblSymbolValue.text = smData.symbolShortName
        lblLastPriceValue.text = smData.closePrice.currencyFormat(2)
        lblBuyQuotValue.text = smData.benchmarkBuy.currencyFormat(2)
        lblSellQuotValue.text = smData.benchmarkSales.currencyFormat(2)
        if smData.todayProfit > 0 {
            lblTodayValue.textColor = UIColor.greenColor()
        } else if smData.todayProfit < 0 {
            lblTodayValue.textColor = UIColor.redColor()
        }
        
        if smData.totalProfit > 0 {
            lblOverValue.textColor = UIColor.greenColor()
        } else if smData.totalProfit < 0 {
            lblOverValue.textColor = UIColor.redColor()
        }
        
        if smData.lastTradePriceChange > 0 {
            imgChanges.image = UIImage(named: UIConstants.icIncrease)
            lblEndChanges.textColor = UIColor.greenColor()
        } else if smData.lastTradePriceChange < 0 {
            imgChanges.image = UIImage(named: UIConstants.icDecrease)
            lblEndChanges.textColor = UIColor.redColor()
        }
        
        switch smData.status.trim() {
        case "A":
            lblStatusValue.text = Strings.portfolio_authorized.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        case "AG":
            lblStatusValue.text = Strings.portfolio_authorized_closed.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        case "AS":
            lblStatusValue.text = Strings.portfolio_authorized_stop.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        case "AR":
            lblStatusValue.text = Strings.portfolio_authorized_protected.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        case "AR":
            lblStatusValue.text = Strings.portfolio_authorized_protected.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        case "O":
            lblStatusValue.text = Strings.portfolio_open.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        case "I":
            lblStatusValue.text = Strings.portfolio_forbidden.localized()
            viewStatus.backgroundColor = UIColor.redColor()
        case "IG":
            lblStatusValue.text = Strings.portfolio_forbidden_closed.localized()
            viewStatus.backgroundColor = UIColor.redColor()
        case "IS":
            lblStatusValue.text = Strings.portfolio_forbidden_stop.localized()
            viewStatus.backgroundColor = UIColor.redColor()
        default:
            lblStatusValue.text = Strings.portfolio_open.localized()
            viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        }
        
        lblTodayValue.text = abs(smData.todayProfit).currencyFormat(2)
        lblOverValue.text = abs(smData.totalProfit).currencyFormat(2)
        lblEndValue.text = smData.lastTradePrice.currencyFormat(2)
        let changePercent = abs(smData.lastTradePriceChangePercent.roundToPlaces(2))
        let changePercentString = changePercent == 0 ? "0" : String(changePercent)
        lblEndChanges.text = abs(smData.lastTradePriceChange).currencyFormat(2) + " (%" + changePercentString + ")"

        backgroundView?.backgroundColor = AppMainColor
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
