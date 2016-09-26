//
//  SymbolListTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire

class SymbolListTableViewController: BaseTableViewController {
    
    //MARK: Properties
    var numberSortCondiiton = SortCondition.notSorted
    var volumeSortCondiiton = SortCondition.notSorted
    var symbolSortCondiiton = SortCondition.notSorted
    //    var symbolName = [String]()
    //    var lastTradeValue = [Double]()
    //    var lastTradeChange = [Double]()
    //    var symbolVolume = [String]()
    //    var symbolAmount = [Int]()
    //    var symbolCode = [String]()
    var symbolDetailsList = [SymbolDetailsList]()
    var temp = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "SymbolListHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "SymbolListHeader")
        self.tableView.tableFooterView = UIView()
        
        
        //        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //        let attrText = NSAttributedString(string: "Pull to Refresh", attributes: titleAttributes)
        refreshControl = UIRefreshControl()
        //        refreshControl!.attributedTitle = attrText
        refreshControl!.tintColor = UIColor.whiteColor()
        refreshControl!.addTarget(self, action: #selector(SymbolListTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
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
        return symbolDetailsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("symbolCell", forIndexPath: indexPath) as! SymbolCell
        
        let tempVol = Double(symbolDetailsList[indexPath.row].transactionVolume)
        let tempLastTrader = Int(symbolDetailsList[indexPath.row].lastTradePriceChange)
        cell.lblName.text = symbolDetailsList[indexPath.row].symbolNameFa
        cell.lblLastTrade.text = symbolDetailsList[indexPath.row].lastTradePrice.currencyFormat()
        cell.lblLastTradeChanges.text = String(abs(tempLastTrader))
        cell.lblVolume.text = tempVol.suffixNumber()
        cell.lblAmount.text = String(symbolDetailsList[indexPath.row].transactionNumber)
        if symbolDetailsList[indexPath.row].lastTradePriceChange > 0{
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
        
        let tapGestureAmount = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureVolume = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        let tapGestureName = UITapGestureRecognizer(target: self, action: #selector(SymbolListTableViewController.performSort(_:)))
        headerView.lblAmount.addGestureRecognizer(tapGestureAmount)
        headerView.lblAmount.userInteractionEnabled = true
        headerView.lblVolume.addGestureRecognizer(tapGestureVolume)
        headerView.lblVolume.userInteractionEnabled = true
        headerView.lblName.addGestureRecognizer(tapGestureName)
        headerView.lblName.userInteractionEnabled = true
        
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
        SelectedSymbolCode = symbolDetailsList[indexPath.row].symbolCode
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
        Request.postData(url, body: body as? [String : AnyObject]) { (symbols:MainResponse<SymbolListByIndexResponse>?, error) in
            
            if ((symbols?.successful) != nil) {
                self.symbolDetailsList.removeAll()
                for i in 0  ..< symbols!.response.symbolDetailsList.count{
                    self.symbolDetailsList.append(symbols!.response.symbolDetailsList[i])
                    self.tableView.reloadData()
                }
            } else {
                debugPrint(error)
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: Actions
    
    func performSort(sender: UITapGestureRecognizer) {
        switch sender.view!.restorationIdentifier! {
        case "lblAmount":
            switch numberSortCondiiton {
            case .notSorted:
                self.numberSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionNumber < $0.transactionNumber
                })
                break
            case .decending:
                self.numberSortCondiiton = .accending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionNumber > $0.transactionNumber
                })
                break
            case .accending:
                self.numberSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionNumber < $0.transactionNumber
                })
                break
            }
            break
        case "lblVolume":
            switch volumeSortCondiiton {
            case .notSorted:
                self.volumeSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionVolume < $0.transactionVolume
                })
                break
            case .decending:
                self.volumeSortCondiiton = .accending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionVolume > $0.transactionVolume
                })
                break
            case .accending:
                self.volumeSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    $1.transactionVolume < $0.transactionVolume
                })
                break
            }
            break
        case "lblSymbol":
            switch symbolSortCondiiton {
            case .notSorted:
                self.symbolSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    return persianStringCompare($1.symbolNameFa, value2: $0.symbolNameFa)
                })
                break
            case .decending:
                self.symbolSortCondiiton = .accending
                self.symbolDetailsList.sortInPlace({
                    return persianStringCompare($0.symbolNameFa, value2: $1.symbolNameFa)
                })
                break
            case .accending:
                self.symbolSortCondiiton = .decending
                self.symbolDetailsList.sortInPlace({
                    return persianStringCompare($1.symbolNameFa, value2: $0.symbolNameFa)
                })
                break
            }
            break
        default:break
        }
        
        self.tableView.reloadData()
    }
    
    
    
}

public enum SortCondition {
    case accending
    case decending
    case notSorted
}