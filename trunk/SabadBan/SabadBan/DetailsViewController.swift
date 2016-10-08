//
//  DetailsViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
import FCAlertView
class DetailsViewController:  BaseViewController  , UITableViewDataSource , UITableViewDelegate  {

    //MARK: Properties

    @IBOutlet weak var lblPrice: UILabel!

    @IBOutlet weak var lblPriceChanges: UILabel!

    @IBOutlet weak var imgPriceChanges: UIImageView!
    @IBOutlet weak var lblPricePercent: UILabel!

    @IBOutlet weak var imgPercentChanges: UIImageView!

    @IBOutlet weak var segRange: UISegmentedControl!
    @IBOutlet weak var tblDetails: UITableView!
    @IBOutlet weak var tblMarketDetail: UITableView!

    var maxPrice = Double()
    var minPrice = Double()
    var lastPrice = Double()
    var priceChanges = Double()
    var priceChangesPercent = Double()
    var range = String()
    var indexDetailsRefreshControl: UIRefreshControl!
    var marketDetailsRefreshControl: UIRefreshControl!

    var marketValue = Double()
    var numberOfTransactions = Double()
    var valueOfTransactions = Double()
    var volumeOfTransactions = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        segRange.setTitle(Strings.Day.localized(), forSegmentAtIndex: 3)
        segRange.setTitle(Strings.Week.localized(), forSegmentAtIndex: 2)
        segRange.setTitle(Strings.Month.localized(), forSegmentAtIndex: 1)
        segRange.setTitle( Strings.Year.localized(), forSegmentAtIndex: 0)
        segRange.selectedSegmentIndex = 3

        tblDetails.registerNib(UINib(nibName: UIConstants
            .IndexDetailHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants
                .IndexDetailHeader)
        self.tblDetails.dataSource = self
        tblDetails.delegate = self
        tblDetails.tableFooterView = UIView()

        tblMarketDetail.registerNib(UINib(nibName: UIConstants.MarketDetailsHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.MarketDetailsHeader)
        tblMarketDetail.dataSource = self
        tblMarketDetail.delegate = self

        //        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.whiteColor()]
        //
        //        let attrText = NSAttributedString(string: "Pull to Refresh", attributes: titleAttributes)
        indexDetailsRefreshControl = UIRefreshControl()
        //        refreshControl.attributedTitle = attrText
        indexDetailsRefreshControl.tintColor = UIColor.whiteColor()

        self.tblDetails.contentOffset = CGPointMake(0, -self.indexDetailsRefreshControl!.frame.size.height)
        indexDetailsRefreshControl.addTarget(self, action: #selector(DetailsViewController.refreshIndexDetails(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tblDetails.addSubview(indexDetailsRefreshControl)

        marketDetailsRefreshControl = UIRefreshControl()
        marketDetailsRefreshControl.tintColor = UIColor.whiteColor()
        self.tblMarketDetail.contentOffset = CGPointMake(0, -self.marketDetailsRefreshControl!.frame.size.height)

        marketDetailsRefreshControl.addTarget(self, action: #selector(DetailsViewController.refreshMarketDetails(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tblMarketDetail.addSubview(marketDetailsRefreshControl)

        getIndexDetails(SelectedIndexCode, range:segRange.selectedSegmentIndex )
        getMarketActivity()

    }

    func refreshIndexDetails(sender:AnyObject) {
        getIndexDetails(SelectedIndexCode, range:segRange.selectedSegmentIndex )
    }

    func refreshMarketDetails(sender:AnyObject) {
        getMarketActivity()
    }

    // MARK:-  TableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblDetails{
            return 5
        } else if tableView == tblMarketDetail {
            return 4
        }
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == tblDetails {
            let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.indexDetailsCell, forIndexPath: indexPath) as! indexDetailsCell

            switch indexPath.row {
            case 0:
                cell.lblTitle.text = Strings.MaxPrice.localized()
                cell.lblValue.text = maxPrice.currencyFormat(2)
            case 1:
                cell.lblTitle.text = Strings.MinPrice.localized()
                cell.lblValue.text = minPrice.currencyFormat(2)
            case 2:
                cell.lblTitle.text = Strings.LastPrice.localized()
                cell.lblValue.text = lastPrice.currencyFormat(2)
            case 3:
                cell.lblTitle.text = Strings.PriceChanges.localized()
                cell.lblValue.text = String(priceChanges)
            case 4:
                cell.lblTitle.text = Strings.PriceChangesPercent.localized()
                cell.lblValue.text = "%" + String(priceChangesPercent)
            default:
                cell.lblTitle.text = "."
                cell.lblValue.text = "."
            }
            cell.lblTitle.numberOfLines = 0
            cell.lblTitle.sizeToFit()
            cell.lblTitle.adjustsFontSizeToFitWidth = true
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = AppBarTintColor
            }else {
                cell.backgroundColor = AppMainColor
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.marketDetailsCell, forIndexPath: indexPath) as! MarketDetailsCell

            switch indexPath.row {
            case 0:
                cell.lblTitle.text = Strings.NumberOfTransactions.localized()
                cell.lblValue.text = numberOfTransactions.currencyFormat(2)
            case 1:
                cell.lblTitle.text = Strings.ValueOfTransactions.localized()
                cell.lblValue.text = valueOfTransactions.suffixNumber()
            case 2:
                cell.lblTitle.text = Strings.VolumeOfTransactions.localized()
                cell.lblValue.text = volumeOfTransactions.suffixNumber()
            case 3:
                cell.lblTitle.text = Strings.ValueOfMarket.localized()
                cell.lblValue.text = marketValue.suffixNumber()
            default:
                cell.lblTitle.text = "."
                cell.lblValue.text = "."
            }
            cell.lblTitle.numberOfLines = 0
            cell.lblTitle.sizeToFit()
            cell.lblTitle.adjustsFontSizeToFitWidth = true
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = AppBarTintColor
            }else {
                cell.backgroundColor = AppMainColor
            }

            return cell
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 35
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblDetails {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.IndexDetailHeader) as! IndexDetailHeader

            headerView.lblTitle.text = Strings.indexInfo.localized()
            headerView.lblTitle.setDefaultFont()
            headerView.backView.roundCorners([.TopLeft, .TopRight], radius: 6)
            return headerView
        } else {
            let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.MarketDetailsHeader) as! MarketDetailsHeader

            headerView.lblTitle.text = Strings.marketInfo.localized()
            headerView.lblTitle.setDefaultFont()
            headerView.backView.roundCorners([.TopLeft, .TopRight], radius: 6)
            return headerView
        }
    }

    @IBAction func segmentChanged(sender: AnyObject) {
        getIndexDetails(SelectedIndexCode, range:segRange.selectedSegmentIndex )
        getMarketActivity()

    }

    // MARK:- Service Methods

    func getIndexDetails(indexCode:String , range:Int){

        indexDetailsRefreshControl.beginRefreshing()
        let url = AppTadbirUrl + URLS["IndexListAndDetails"]!
        // Add Headers

        // JSON Body
        let body = IndexDetailsRequest(timeFrameType: TimeFrameType(rawValue: (3 - range)), indexCode: indexCode, language: getAppLanguage()).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (indexs:MainResponse<Response>?, error)  in
            if ((indexs?.successful) != nil) {
                if (indexs!.response.indexDetailsList.count > 0) {
                    debugPrint("Count: \(indexs!.response.indexDetailsList.count)")
                    self.maxPrice = Double(indexs!.response.indexDetailsList[0].highPrice)
                    self.minPrice = Double(indexs!.response.indexDetailsList[0].lowPrice)
                    self.lastPrice = Double(indexs!.response.indexDetailsList[0].closePrice)
                    self.priceChanges = Double(indexs!.response.indexDetailsList[0].changePriceOnSameTime)
                    self.priceChangesPercent = Double(indexs!.response.indexDetailsList[0].changePricePercentOnSameTime)
                    self.lblPrice.text = self.lastPrice.currencyFormat(2)
                    self.lblPriceChanges.text = self.priceChanges.currencyFormat(2)
                    self.lblPricePercent.text  = String(self.priceChangesPercent)
                    self.tblDetails.reloadData()
                }else{

                    let alert = FCAlertView()
                    alert.makeAlertTypeCaution()
                    alert.colorScheme = UIColor.blueColor()
                    alert.showAlertInView(self,
                                          withTitle: Strings.Warning.localized(),
                                          withSubtitle: Strings.noData.localized(),
                                          withCustomImage: nil,
                                          withDoneButtonTitle: Strings.Done.localized(),
                                          andButtons: nil)
                }

            } else {
                debugPrint(error)
            }

            self.indexDetailsRefreshControl.endRefreshing()
        }

    }

    func getMarketActivity() {
        marketDetailsRefreshControl.beginRefreshing()
        let url = AppTadbirUrl + URLS["getMarketActivity"]!

        // Fetch Request
        Request.postData(url) { (marketInfo:MainResponse<MarketActivityModel>?, error) in
            if ((marketInfo?.successful) != nil) {
                self.marketValue = Double(marketInfo!.response.marketValue)
                self.numberOfTransactions = marketInfo!.response.numberOfTransactions
                self.valueOfTransactions = Double(marketInfo!.response.valueOfTransactions)
                self.volumeOfTransactions = Double(marketInfo!.response.volumeOfTransactions)

                self.tblMarketDetail.reloadData()
            } else {
                debugPrint(error)
            }
            self.marketDetailsRefreshControl.endRefreshing()
        }
    }

}
