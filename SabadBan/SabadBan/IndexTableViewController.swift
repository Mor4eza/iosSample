//
//  IndexTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class IndexTableViewController: BaseTableViewController ,DialogClickDelegate{
    
    
    var indexNames = [String]()
    var indexPrice = [Double]()
    var indexPercent = [Double]()
    var indexCode = [String]()
    var selectedIndexCode = String()
    var selectedIndexName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addMenuButton()
        setTexts()
        tableView.registerNib(UINib(nibName: "IndexHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "IndexHeader")
        
        self.tableView.tableFooterView = UIView()
        
        //        let titleAttributes = [NSFontAttributeName: UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //        let attrText = NSAttributedString(string: "Pull to Refresh", attributes: titleAttributes)
        refreshControl = UIRefreshControl()
        //        refreshControl!.attributedTitle = attrText
        refreshControl!.tintColor = UIColor.whiteColor()
        refreshControl!.addTarget(self, action: #selector(IndexTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        getIndexList()
        
        
    }
    func refresh(sender:AnyObject) {
        getIndexList()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return indexNames.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("indexCell", forIndexPath: indexPath) as! IndexCell
        
        cell.lblIndexName.text = indexNames[indexPath.row]
        cell.imgIndex.image = UIImage(named: "ic_increase")
        if (indexPercent[indexPath.row] < 0){
            cell.imgIndex.image = UIImage(named: "ic_decrease")
        }
        let price:NSNumber = indexPrice[indexPath.row]
        cell.lblIndexCount.text = price.currencyFormat()
        cell.lblIndexPercent.text = "%" + String(indexPercent[indexPath.row])
        cell.lblIndexName.sizeToFit()
        cell.lblIndexCount.sizeToFit()
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("IndexHeader") as! IndexHeader
        
        headerView.lblPercent.text = "Percent".localized()
        headerView.lblCount.text = "Count".localized()
        headerView.lblIndex.text = "Index".localized()
        
        headerView.lblPercent.setDefaultFont()
        headerView.lblCount.setDefaultFont()
        headerView.lblIndex.setDefaultFont()
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexCode = indexCode[indexPath.row]
        selectedIndexName = indexNames[indexPath.row]
        
    }
    
    
    
    func ShowAlert(sender: AnyObject) {
        
        
        let alert: MyAlert = {
            let alert = MyAlert()
            return alert
        }()
        alert.delegate = self
        alert.showAlert("hello", details: "This is Alert", okTitle: "Ok", cancelTitle: "cancel", onView: view)
        
    }
    
    func setTexts(){
        self.title = "APP_NAME".localized()
    }
    
    func dialogOkButtonClicked() {
        debugPrint("ok Clicked")
        
    }
    func dialogCancelButtonClicked() {
        debugPrint("cancel Clicked")
    }
    
    // MARK: - Service
    func getIndexList (){
        
        refreshControl?.beginRefreshing()
        let url = AppTadbirUrl + URLS["IndexListAndDetails"]!
        // Add Headers
        
        
        // JSON Body
        let body = [
            "timeFrameType": "day",
            "indexCode": "0"
        ]
        
        // Fetch Request
        Alamofire.request(.POST,url, headers: ServicesHeaders, parameters: body, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(MainResponse<Response>.self) { response in
                
                switch response.result {
                case .Success(let indexs):
                    self.indexNames.removeAll()
                    self.indexCode.removeAll()
                    self.indexPrice.removeAll()
                    self.indexPercent.removeAll()
                    for i in 0  ..< indexs.response.indexDetailsList.count{
                        self.indexNames.append(indexs.response.indexDetailsList[i].nameFa)
                        self.indexPrice.append(Double(indexs.response.indexDetailsList[i].closePrice))
                        self.indexPercent.append(indexs.response.indexDetailsList[i].changePricePercentOnSameTime)
                        self.indexCode.append(indexs.response.indexDetailsList[i].indexCode)
                        self.tableView.reloadData()
                    }
                    break
                case .Failure(let error):
                    debugPrint(error)
                }
                self.refreshControl?.endRefreshing()
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "IndexDetailSegue") {
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let currentCell = self.tableView.cellForRowAtIndexPath(indexPath)! as! IndexCell
            
            SelectedIndexCode = indexCode[indexPath.row]
            let svc = segue.destinationViewController as! IndexDetailsTabBarController;
            svc.selectedIndexName = currentCell.lblIndexName.text!
            
        }
    }
    
}
