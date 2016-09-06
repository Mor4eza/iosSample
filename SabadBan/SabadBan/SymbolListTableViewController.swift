//
//  SymbolListTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_Gloss
class SymbolListTableViewController: BaseTableViewController {
    
    
    var symbolName = [String]()
    var lastTradeValue = [Double]()
    var lastTradeChange = [Double]()
    var symbolVolume = [String]()
    var symbolAmount = [Int]()
    var symbolCode = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "SymbolListHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SymbolListHeader")
        self.tableView.tableFooterView = UIView()
        
        
        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let attrText = NSAttributedString(string: "Pull to Refresh", attributes: titleAttributes)
        refreshControl = UIRefreshControl()
        refreshControl!.attributedTitle = attrText
        refreshControl!.tintColor = UIColor.whiteColor()
        refreshControl!.addTarget(self, action: #selector(DetailsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        getSymbolListByIndex()
        
    }
    func refresh(sender:AnyObject) {
        getSymbolListByIndex()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return symbolName.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("symbolCell", forIndexPath: indexPath) as! SymbolCell
        
        let tempVol = Double(symbolVolume[indexPath.row])
        let tempLastTrader = Int(lastTradeChange[indexPath.row])
        cell.lblName.text = symbolName[indexPath.row]
        cell.lblLastTrade.text = lastTradeValue[indexPath.row].currencyFormat()
        cell.lblLastTradeChanges.text = String(abs(tempLastTrader))
        cell.lblVolume.text = tempVol?.suffixNumber()
        cell.lblAmount.text = String(symbolAmount[indexPath.row])
        if lastTradeChange[indexPath.row] > 0{
            cell.lblLastTradeChanges.backgroundColor = UIColor(netHex: 0x006400)
        }else{
            cell.lblLastTradeChanges.backgroundColor = UIColor.redColor()
        }
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = AppBarTintColor
        }else {
            cell.backgroundColor = AppMainColor
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("SymbolListHeader") as! SymbolListHeader
        
        
        headerView.lblName.text = "Symbol".localized()
        headerView.lblLastTrade.text = "Trade".localized()
        headerView.lblAmount.text = "Amount".localized()
        headerView.lblVolume.text = "Volume".localized()
        
        headerView.lblName.setDefaultFont()
        headerView.lblLastTrade.setDefaultFont()
        headerView.lblAmount.setDefaultFont()
        headerView.lblVolume.setDefaultFont()
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SelectedSymbolCode = symbolCode[indexPath.row]
    }
    
    //MARK: - Service Call
    
    func getSymbolListByIndex (){
        
        refreshControl?.beginRefreshing()
        let url = AppTadbirUrl + URLS["getSymbolListByIndex"]!
        
        
        // JSON Body
        let body = [
            "timeFrameType": "day",
            "pageNumber": 0,
            "supportPaging": false,
            "recordPerPage": 0,
            "indexCode": SelectedIndexCode
        ]
        
        // Fetch Request
        Alamofire.request(.POST,url, headers: ServicesHeaders, parameters: body as? [String : AnyObject], encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObject(IndexSymbolsList.self) { response in
                
                switch response.result {
                case .Success(let symbols):
                    self.symbolName.removeAll()
                    self.lastTradeValue.removeAll()
                    self.lastTradeChange.removeAll()
                    self.symbolVolume.removeAll()
                    self.symbolAmount.removeAll()
                    self.symbolCode.removeAll()
                    for i in 0  ..< symbols.response.symbolDetailsList.count{
                        self.symbolName.append(symbols.response.symbolDetailsList[i].symbolNameFa)
                        self.lastTradeValue.append(Double(symbols.response.symbolDetailsList[i].lastTradePrice))
                        self.lastTradeChange.append(Double(symbols.response.symbolDetailsList[i].lastTradePriceChange))
                        self.symbolVolume.append(String(symbols.response.symbolDetailsList[i].transactionVolume))
                        self.symbolAmount.append(Int(symbols.response.symbolDetailsList[i].transactionNumber))
                        self.symbolCode.append(symbols.response.symbolDetailsList[i].symbolCode)
                        self.tableView.reloadData()
                    }
                    break
                case .Failure(let error):
                    debugPrint(error)
                }
                self.refreshControl?.endRefreshing()
        }
    }
    
    
    
    
}
