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

    var hideBestBuy = true
    var hideBestSell = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        tableView.registerNib(UINib(nibName: UIConstants.buyHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.buyHeader)
        debugPrint("selected: \(SelectedSymbolCode)")
        getSymbolBestLimitService(String(SelectedSymbolCode))
        getSymbolTradingDetailsService(String(SelectedSymbolCode))
        getSymbolListData([String(SelectedSymbolCode)])
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 1
        }else if section == 1{
            if hideBestBuy {
                return 0
            }
        }else if section == 2 {
            if hideBestSell {
                return 0
            }

        }
        return 1

    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {

        let tapGesture = UITapGestureRecognizer()

        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.buyHeader) as! SymbolBestBuyAndCellHeader
        headerView.addGestureRecognizer(tapGesture)

        tableView.backgroundColor = AppMainColor

        if (section == 1) {
            tapGesture.addTarget(self, action: #selector(self.bestBuyTapped))
            headerView.lblTitle.text = Strings.bestBuyTitle.localized()
            headerView.lblTitle.backgroundColor = UIColor(netHex: 0x2e9220)
            if hideBestBuy {
                rotateWithAnimation(headerView.imgArrow, angle: M_PI)
            }else {
                rotateWithAnimation(headerView.imgArrow, angle: 0)
            }
        } else if (section == 2) {
            tapGesture.addTarget(self, action: #selector(self.bestSellTapped))
            headerView.lblTitle.text = Strings.bestSellTitle.localized()
            headerView.lblTitle.backgroundColor = UIColor.redColor()
            if hideBestSell {
                rotateWithAnimation(headerView.imgArrow, angle: M_PI)
            }else {
                rotateWithAnimation(headerView.imgArrow, angle: 0)
            }
        }
        headerView.lblTitle.textColor = UIColor.whiteColor()
        headerView.lblTitle.setDefaultFont()
        return headerView
    }


    func bestBuyTapped(){
        hideBestBuy = !hideBestBuy
        tableView.reloadSections(NSIndexSet(index:1), withRowAnimation: .Fade)
    }

    func bestSellTapped(){
        hideBestSell = !hideBestSell
        //        let indexPath = NSIndexPath(forRow:2, inSection: 2)
        tableView.reloadSections(NSIndexSet(index:2), withRowAnimation: .Fade)
        //        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
        //        tableView.contentOffset = CGPointMake(0, 120)
    }


    func rotateWithAnimation(target: UIImageView, angle: Double) {
        UIView.animateWithDuration(0.25, animations: {
            target.transform = CGAffineTransformMakeRotation(CGFloat(angle))
        })
    }

    //MARK:- Symbol Best Limit service

    func getSymbolBestLimitService(sCode:String){
        /**
         getBestLimitsBySymbol
         POST http://185.37.52.193:9090/services/getBestLimitsBySymbol
         */

        let url = AppTadbirUrl + URLS["getBestLimitsBySymbol"]!

        // JSON Body
        let body = SymbolBestLimitRequest(symbolCode: sCode).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (bestLimit:MainResponse<SymbolBestLimitResponse>?, error) in

            if ((bestLimit?.successful) != nil) {
                if  bestLimit!.response.bestLimitDataList.count > 0 {
                    self.lblBBPValue1.text = bestLimit!.response.bestLimitDataList[0].buyPrice.currencyFormat(2)
                    self.lblBBPValue2.text = bestLimit!.response.bestLimitDataList[1].buyPrice.currencyFormat(2)
                    self.lblBBPValue3.text = bestLimit!.response.bestLimitDataList[2].buyPrice.currencyFormat(2)
                    self.lblBBVValue1.text = bestLimit!.response.bestLimitDataList[0].buyValue.currencyFormat(2)
                    self.lblBBVValue2.text = bestLimit!.response.bestLimitDataList[1].buyValue.currencyFormat(2)
                    self.lblBBVValue3.text = bestLimit!.response.bestLimitDataList[2].buyValue.currencyFormat(2)
                    self.lblBBCValue1.text = bestLimit!.response.bestLimitDataList[0].buyNumber.currencyFormat(2)
                    self.lblBBCValue2.text = bestLimit!.response.bestLimitDataList[1].buyNumber.currencyFormat(2)
                    self.lblBBCValue3.text = bestLimit!.response.bestLimitDataList[2].buyNumber.currencyFormat(2)

                    self.lblBSPValue1.text = bestLimit!.response.bestLimitDataList[0].sellPrice.currencyFormat(2)
                    self.lblBSPValue2.text = bestLimit!.response.bestLimitDataList[1].sellPrice.currencyFormat(2)
                    self.lblBSPValue3.text = bestLimit!.response.bestLimitDataList[2].sellPrice.currencyFormat(2)
                    self.lblBSVValue1.text = bestLimit!.response.bestLimitDataList[0].sellValue.currencyFormat(2)
                    self.lblBSVValue2.text = bestLimit!.response.bestLimitDataList[1].sellValue.currencyFormat(2)
                    self.lblBSVValue3.text = bestLimit!.response.bestLimitDataList[2].sellValue.currencyFormat(2)
                    self.lblBSCValue1.text = bestLimit!.response.bestLimitDataList[0].sellNumber.currencyFormat(2)
                    self.lblBSCValue2.text = bestLimit!.response.bestLimitDataList[1].sellNumber.currencyFormat(2)
                    self.lblBSCValue3.text = bestLimit!.response.bestLimitDataList[2].sellNumber.currencyFormat(2)
                }
            } else {
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
        let body = SymbolTradingRequest(symbolCode: sCode).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (trading:MainResponse<SymbolTradingResponse>?, error) in

            if ((trading?.successful) != nil) {
                if trading!.response != nil {
                    self.lblCount1Value.text = trading!.response.buyNumberLegal.currencyFormat(2)
                    self.lblCount2Value.text = trading!.response.buyNumberReal.currencyFormat(2)
                    self.lblCount3Value.text = trading!.response.sellNumberLegal.currencyFormat(2)
                    self.lblCount4Value.text = trading!.response.sellNumberReal.currencyFormat(2)
                    self.lblVolume1value.text = trading!.response.buyVolumeLegal.currencyFormat(2)
                    self.lblVolume2value.text = trading!.response.buyVolumeReal.currencyFormat(2)
                    self.lblVolume3value.text = trading!.response.sellVolumeLegal.currencyFormat(2)
                    self.lblVolume4value.text = trading!.response.sellVolumeReal.currencyFormat(2)
                }
            } else {
                debugPrint(error)
            }
        }

    }

    func getSymbolListData(sCode:[String]) {

        let url = AppTadbirUrl + URLS["getSymbolListAndDetails"]!

        // JSON Body
        let body = SymbolListAndDetailsRequest(pageNumber: 0, recordPerPage: 0, symbolCode: sCode, supportPaging: false,language: getAppLanguage()).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (symbol:MainResponse<SymbolListByIndexResponse>?, error) in

            if ((symbol?.successful) != nil) {
                if symbol!.response.symbolDetailsList.count > 0 {
                    self.lblLastPriceValue.text = symbol!.response.symbolDetailsList[0].closePrice.currencyFormat(2)
                    self.lblLastPriceChanges.text = String(symbol!.response.symbolDetailsList[0].closePriceChange)
                    self.lblLastPriceDate.text = ""
                    self.lblLastPriceValues.text = symbol!.response.symbolDetailsList[0].lastTradePrice.currencyFormat(2)
                    self.lblStartPriceValue.text = symbol!.response.symbolDetailsList[0].openPrice.currencyFormat(2)
                    self.lblLowPriceValue.text = symbol!.response.symbolDetailsList[0].lowPrice.currencyFormat(2)
                    self.lblhighPriceValue.text = symbol!.response.symbolDetailsList[0].highPrice.currencyFormat(2)
                    self.lblLastPriceChanges.text = " \(abs(symbol!.response.symbolDetailsList[0].lastTradePriceChange)) (%\(abs(symbol!.response.symbolDetailsList[0].lastTradePriceChangePercent.roundToPlaces(2))))"
                    if symbol!.response.symbolDetailsList[0].lastTradePriceChange > 0 {
                        self.lblLastPriceChanges.textColor = UIColor.greenColor()
                    } else{
                        self.lblLastPriceChanges.textColor = UIColor.redColor()
                    }
                } else {
                    debugPrint(error)
                }
                //                self.refreshControll?.endRefreshing()
            }
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
            
            lblLastPriceTitle.text = Strings.LastPriceTitle.localized()
            lblEndPriceTitle.text = Strings.EndPriceTitle.localized()
            lblStartPriceTitle.text = Strings.StartPriceTitle.localized()
            lblLowPriceTitle.text = Strings.LowPriceTitle.localized()
            lblHighPriceTitle.text = Strings.HighPriceTitle.localized()
        }
        
}
