//
//  SymbolDetailsViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/6/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire

class SymbolDetailsViewController: BaseTableViewController {
    
    
    @IBOutlet weak var lblBuyTitle: UILabel!
    @IBOutlet weak var lblCellTitle: UILabel!
    @IBOutlet weak var lblkindTitle: UILabel!
    @IBOutlet weak var lblReal1Title: UILabel!
    @IBOutlet weak var lblReal2Title: UILabel!
    @IBOutlet weak var lblLegal1Title: UILabel!
    @IBOutlet weak var lblLegal2Title: UILabel!
    @IBOutlet weak var lblCountTitle: UILabel!
    @IBOutlet weak var lblCount1Value: UILabel!
    @IBOutlet weak var lblCount2Value: UILabel!
    @IBOutlet weak var lblCount3Value: UILabel!
    @IBOutlet weak var lblCount4Value: UILabel!
    @IBOutlet weak var lblVolumeTitle: UILabel!
    @IBOutlet weak var lblVolume1value: UILabel!
    @IBOutlet weak var lblVolume2value: UILabel!
    @IBOutlet weak var lblVolume3value: UILabel!
    @IBOutlet weak var lblVolume4value: UILabel!
    @IBOutlet weak var lblLastPriceTitle: UILabel!
    @IBOutlet weak var lblLastPriceDate: UILabel!
    @IBOutlet weak var lblLastPriceChanges: UILabel!
    @IBOutlet weak var lblLastPriceValues: UILabel!
    @IBOutlet weak var lblEndPriceTitle: UILabel!
    @IBOutlet weak var lblLastPriceValue: UILabel!
    @IBOutlet weak var lblStartPriceTitle: UILabel!
    @IBOutlet weak var lblStartPriceValue: UILabel!
    @IBOutlet weak var lblLowPriceTitle: UILabel!
    @IBOutlet weak var lblLowPriceValue: UILabel!
    @IBOutlet weak var lblHighPriceTitle: UILabel!
    @IBOutlet weak var lblhighPriceValue: UILabel!
    //Section 2 BestBuy
    @IBOutlet weak var lblBBPTitle:  UILabel!
    @IBOutlet weak var lblBBPValue1: UILabel!
    @IBOutlet weak var lblBBPValue2: UILabel!
    @IBOutlet weak var lblBBPValue3: UILabel!
    @IBOutlet weak var lblBBVTitle: UILabel!
    @IBOutlet weak var lblBBVValue1: UILabel!
    @IBOutlet weak var lblBBVValue2: UILabel!
    @IBOutlet weak var lblBBVValue3: UILabel!
    @IBOutlet weak var lblBBCTitle: UILabel!
    @IBOutlet weak var lblBBCValue1: UILabel!
    @IBOutlet weak var lblBBCValue2: UILabel!
    @IBOutlet weak var lblBBCValue3: UILabel!
    //Section 3 BestSell
    @IBOutlet weak var lblBSPTitle: UILabel!
    @IBOutlet weak var lblBSPValue1: UILabel!
    @IBOutlet weak var lblBSPValue2: UILabel!
    @IBOutlet weak var lblBSPValue3: UILabel!
    @IBOutlet weak var lblBSVTitle: UILabel!
    @IBOutlet weak var lblBSVValue1: UILabel!
    @IBOutlet weak var lblBSVValue2: UILabel!
    @IBOutlet weak var lblBSVValue3: UILabel!
    @IBOutlet weak var lblBSCTitle: UILabel!
    @IBOutlet weak var lblBSCValue1: UILabel!
    @IBOutlet weak var lblBSCValue2: UILabel!
    @IBOutlet weak var lblBSCValue3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        debugPrint("selected: \(SelectedSymbolCode)")
        getSymbolBestLimitService(SelectedSymbolCode)
        getSymbolTradingDetailsService(SelectedSymbolCode)
        getSymbolListData([SelectedSymbolCode])
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, 50))
        if (section == 1) {
            headerView.text = "سه مظنه برتر خرید"
            headerView.backgroundColor = UIColor(netHex: 0x2e9220)
        } else if (section == 2) {
            headerView.text = "سه مظنه برتر فروش"
            headerView.backgroundColor = UIColor.redColor()
        }
        
        headerView.textColor = UIColor.whiteColor()
        headerView.changeDirection()
        return headerView
    }
    //MARK:- Symbol Best Limit service
    
    func getSymbolBestLimitService(sCode:String){
        /**
         getBestLimitsBySymbol
         POST http://185.37.52.193:9090/services/getBestLimitsBySymbol
         */
        
        let url = AppTadbirUrl + URLS["getBestLimitsBySymbol"]!
        
        // JSON Body
        let body = [
            "symbolCode": sCode
        ]
        
        // Fetch Request
        Alamofire.request(.POST, url, headers: ServicesHeaders, parameters: body, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(MainResponse<SymbolBestLimitResponse>.self) { response in
                
                switch response.result {
                case .Success(let bestLimit):
                    if  bestLimit.response.bestLimitDataList.count > 0 {
                        self.lblBBPValue1.text = bestLimit.response.bestLimitDataList[0].buyPrice.currencyFormat()
                        self.lblBBPValue2.text = bestLimit.response.bestLimitDataList[1].buyPrice.currencyFormat()
                        self.lblBBPValue3.text = bestLimit.response.bestLimitDataList[2].buyPrice.currencyFormat()
                        self.lblBBVValue1.text = bestLimit.response.bestLimitDataList[0].buyValue.currencyFormat()
                        self.lblBBVValue2.text = bestLimit.response.bestLimitDataList[1].buyValue.currencyFormat()
                        self.lblBBVValue3.text = bestLimit.response.bestLimitDataList[2].buyValue.currencyFormat()
                        self.lblBBCValue1.text = bestLimit.response.bestLimitDataList[0].buyNumber.currencyFormat()
                        self.lblBBCValue2.text = bestLimit.response.bestLimitDataList[1].buyNumber.currencyFormat()
                        self.lblBBCValue3.text = bestLimit.response.bestLimitDataList[2].buyNumber.currencyFormat()
                        
                        self.lblBSPValue1.text = bestLimit.response.bestLimitDataList[0].sellPrice.currencyFormat()
                        self.lblBSPValue2.text = bestLimit.response.bestLimitDataList[1].sellPrice.currencyFormat()
                        self.lblBSPValue3.text = bestLimit.response.bestLimitDataList[2].sellPrice.currencyFormat()
                        self.lblBSVValue1.text = bestLimit.response.bestLimitDataList[0].sellValue.currencyFormat()
                        self.lblBSVValue2.text = bestLimit.response.bestLimitDataList[1].sellValue.currencyFormat()
                        self.lblBSVValue3.text = bestLimit.response.bestLimitDataList[2].sellValue.currencyFormat()
                        self.lblBSCValue1.text = bestLimit.response.bestLimitDataList[0].sellNumber.currencyFormat()
                        self.lblBSCValue2.text = bestLimit.response.bestLimitDataList[1].sellNumber.currencyFormat()
                        self.lblBSCValue3.text = bestLimit.response.bestLimitDataList[2].sellNumber.currencyFormat()
                    }
                case .Failure(let error):
                    debugPrint(error)
                }
                
        }
        
    }
    
    
    
    func getSymbolTradingDetailsService(sCode:String){
        /**
         getBestLimitsBySymbol
         POST http://185.37.52.193:9090/services/getBestLimitsBySymbol
         */
        
        let url = AppTadbirUrl + URLS["getSymbolTradingDetails"]!
        
        // JSON Body
        let body = [
            "symbolCode": sCode
        ]
        
        // Fetch Request
        Alamofire.request(.POST, url, headers: ServicesHeaders, parameters: body, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(MainResponse<SymbolTradingResponse>.self) { response in
                
                switch response.result {
                case .Success(let trading):
                    if trading.response != nil {
                        self.lblCount1Value.text = trading.response.buyNumberLegal.currencyFormat()
                        self.lblCount2Value.text = trading.response.buyNumberReal.currencyFormat()
                        self.lblCount3Value.text = trading.response.sellNumberLegal.currencyFormat()
                        self.lblCount4Value.text = trading.response.sellNumberReal.currencyFormat()
                        self.lblVolume1value.text = trading.response.buyVolumeLegal.currencyFormat()
                        self.lblVolume2value.text = trading.response.buyVolumeReal.currencyFormat()
                        self.lblVolume3value.text = trading.response.sellVolumeLegal.currencyFormat()
                        self.lblVolume4value.text = trading.response.sellVolumeReal.currencyFormat()
                    }
                case .Failure(let error):
                    debugPrint(error)
                }
                
        }
        
    }
    
    
    
    
    func getSymbolListData(sCode:[String]) {
        
        let url = AppTadbirUrl + URLS["getSymbolListAndDetails"]!
        let headers = [
            "Content-Type":"application/json",
            ]
        
        // JSON Body
        let body = [
            "pageNumber": 0,
            "recordPerPage": 0,
            "symbolCode": sCode,
            "supportPaging": false
        ]
        
        // Fetch Request
        Alamofire.request(.POST, url, headers: headers, parameters: body as? [String : AnyObject], encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(MainResponse<SymbolListByIndexResponse>.self) { response in
                
                switch response.result {
                case .Success(let symbol):
                  
                    if symbol.response.symbolDetailsList.count > 0 {
                        self.lblLastPriceValues.text = symbol.response.symbolDetailsList[0].closePrice.currencyFormat()
                        self.lblLastPriceChanges.text = String(symbol.response.symbolDetailsList[0].closePriceChange)
                        self.lblLastPriceDate.text = ""
                        self.lblLastPriceValue.text = symbol.response.symbolDetailsList[0].lastTradePrice.currencyFormat()
                        self.lblStartPriceValue.text = symbol.response.symbolDetailsList[0].lowPrice.currencyFormat()
                        self.lblLowPriceValue.text = symbol.response.symbolDetailsList[0].lowPrice.currencyFormat()
                        self.lblhighPriceValue.text = symbol.response.symbolDetailsList[0].highPrice.currencyFormat()
                    }
                case .Failure(let error):
                    debugPrint(error)
                }
                //                self.refreshControll?.endRefreshing()
        }
    }
    
    
    
    func setUpViews(){
        
        lblBuyTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblCellTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblkindTitle.font  = UIFont(name: AppFontName_IranSans, size: 14.0)
        lblReal1Title.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblReal2Title.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLegal1Title.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLegal2Title.font  = UIFont(name: AppFontName_IranSans, size: 14.0)
        lblCountTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblCount1Value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblCount2Value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblCount3Value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblCount4Value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblVolumeTitle.font  = UIFont(name: AppFontName_IranSans, size: 14.0)
        lblVolume1value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblVolume2value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblVolume3value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblVolume4value.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLastPriceDate.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLastPriceTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLastPriceChanges.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLastPriceValues.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblEndPriceTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLastPriceValue.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblStartPriceTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblStartPriceValue.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLowPriceTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblLowPriceValue.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblHighPriceTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblhighPriceValue.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBPTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBPValue1.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBPValue2.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBPValue3.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBVTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBVValue1.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBVValue2.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBVValue3.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBCTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBCValue1.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBCValue2.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBBCValue3.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSPTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSPValue1.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSPValue2.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSPValue3.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSVTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSVValue1.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSVValue2.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSVValue3.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSCTitle.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSCValue1.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSCValue2.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        lblBSCValue3.font  = UIFont(name: AppFontName_IranSans, size: 15.0)
        
        lblLastPriceTitle.text = "قیمت آخرین معامله"
        lblEndPriceTitle.text = "قیمت پایانی"
        lblStartPriceTitle.text = "قیمت آغازین"
        lblLowPriceTitle.text = "کمترین قیمت"
        lblHighPriceTitle.text = "بیشترین قیمت"
    }
    
}
