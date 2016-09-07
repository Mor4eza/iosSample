//
//  DetailsViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire

class DetailsViewController:  BaseViewController  , UITableViewDataSource , UITableViewDelegate  {
    
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblPriceChanges: UILabel!
    
    @IBOutlet weak var imgPriceChanges: UIImageView!
    @IBOutlet weak var lblPricePercent: UILabel!
    
    @IBOutlet weak var imgPercentChanges: UIImageView!
    
    @IBOutlet weak var segRange: UISegmentedControl!
     @IBOutlet weak var tblDetails: UITableView!
    var maxPrice = Double()
    var minPrice = Double()
    var lastPrice = Double()
    var priceChanges = Double()
    var priceChangesPercent = Double()
    var range = String()
    var refreshControl: UIRefreshControl!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        segRange.setTitle("Day".localized(), forSegmentAtIndex: 0)
        segRange.setTitle("Week".localized(), forSegmentAtIndex: 1)
        segRange.setTitle("Month".localized(), forSegmentAtIndex: 2)
        segRange.setTitle( "Year".localized(), forSegmentAtIndex: 3)
        
        self.tblDetails.dataSource = self
        tblDetails.delegate = self
        tblDetails.tableFooterView = UIView()
        
//        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.whiteColor()]
//        
//        let attrText = NSAttributedString(string: "Pull to Refresh", attributes: titleAttributes)
        refreshControl = UIRefreshControl()
//        refreshControl.attributedTitle = attrText
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: #selector(DetailsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tblDetails.addSubview(refreshControl)
        getIndexDetails(SelectedIndexCode, range:segRange.selectedSegmentIndex )

    }
    
    func refresh(sender:AnyObject) {
        getIndexDetails(SelectedIndexCode, range:segRange.selectedSegmentIndex )
    }
    
    // MARK:-  TableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("indexDetailsCell", forIndexPath: indexPath) as! indexDetailsCell
        
        
        switch indexPath.row {
        case 0:
            cell.lblTitle.text = "MaxPrice".localized()
            cell.lblValue.text = maxPrice.currencyFormat()
        case 1:
            cell.lblTitle.text = "MinPrice".localized()
            cell.lblValue.text = minPrice.currencyFormat()
        case 2:
            cell.lblTitle.text = "LastPrice".localized()
            cell.lblValue.text = lastPrice.currencyFormat()
        case 3:
            cell.lblTitle.text = "PriceChanges".localized()
            cell.lblValue.text = String(priceChanges)
        case 4:
            cell.lblTitle.text = "PriceChangesPercent".localized()
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
    }
    
    
    
    @IBAction func segmentChanged(sender: AnyObject) {
        getIndexDetails(SelectedIndexCode, range:segRange.selectedSegmentIndex )
        
    }
    
    // MARK:- Service Methods
    
    func getIndexDetails(indexCode:String , range:Int){
        
        refreshControl.beginRefreshing()
        let url = AppTadbirUrl + URLS["IndexListAndDetails"]!
        // Add Headers
        
        
        // JSON Body
        let body = [
            "timeFrameType": range,
            "indexCode":indexCode
        ]
        
        // Fetch Request
        Alamofire.request(.POST,url, headers: ServicesHeaders, parameters: body as? [String : AnyObject], encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(MainResponse<Response>.self) { response in
                switch response.result {
                case .Success(let indexs):
                    if (indexs.response.indexDetailsList.count > 0) {
                        debugPrint("Count: \(indexs.response.indexDetailsList.count)")
                        self.maxPrice = Double(indexs.response.indexDetailsList[0].highPrice)
                        self.minPrice = Double(indexs.response.indexDetailsList[0].lowPrice)
                        self.lastPrice = Double(indexs.response.indexDetailsList[0].closePrice)
                        self.priceChanges = Double(indexs.response.indexDetailsList[0].changePriceOnSameTime)
                        self.priceChangesPercent = Double(indexs.response.indexDetailsList[0].changePricePercentOnSameTime)
                        self.lblPrice.text = self.lastPrice.currencyFormat()
                        self.lblPriceChanges.text = self.priceChanges.currencyFormat()
                        self.lblPricePercent.text  = String(self.priceChangesPercent)
                        self.tblDetails.reloadData()
                    }else{
                        
                    let alert = MyAlert()
                        alert.showAlert("Warning", details: "No Data For seleced Time Frame", okTitle: "Ok", cancelTitle: "", onView: self.view)
                    }
                    break
                    
                case .Failure(let error):
                    debugPrint(error)
                }
                
                self.refreshControl.endRefreshing()
        }
        
        
    }
    
    
    
}
