//
//  IndexTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class IndexTableViewController: BaseTableViewController {

    var indexNames = [String]()
    var indexPrice = [Double]()
    var indexPercent = [Double]()
    var indexCode = [Int64]()
    var selectedIndexCode = String()
    var selectedIndexName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addMenuButton()
        setTexts()
        tableView.registerNib(UINib(nibName: UIConstants.IndexHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.IndexHeader)

        self.tableView.tableFooterView = UIView()
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.whiteColor()
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.indexCell, forIndexPath: indexPath) as! IndexCell

        cell.lblIndexName.text = indexNames[indexPath.row]
        cell.imgIndex.image = UIImage(named: UIConstants.icIncrease)
        if (indexPercent[indexPath.row] < 0){
            cell.imgIndex.image = UIImage(named: UIConstants.icDecrease)
        }
        let price:NSNumber = indexPrice[indexPath.row]
        let percent:NSNumber = indexPercent[indexPath.row]
        cell.lblIndexCount.text = price.currencyFormat(2)
        cell.lblIndexPercent.text = "%" + percent.currencyFormat(2)
        cell.lblIndexName.sizeToFit()
        cell.lblIndexCount.sizeToFit()

        return cell
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (indexNames.count == 0){
            return 0
        }
        return 50
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.IndexHeader) as! IndexHeader

        headerView.lblPercent.text = Strings.Percent.localized()
        headerView.lblCount.text = Strings.Value.localized()
        headerView.lblIndex.text = Strings.Index.localized()

        headerView.lblPercent.setDefaultFont()
        headerView.lblCount.setDefaultFont()
        headerView.lblIndex.setDefaultFont()

        return headerView
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexCode = String(indexCode[indexPath.row])
        selectedIndexName = indexNames[indexPath.row]

    }

    func setTexts(){
        self.title = Strings.Index.localized()
    }

    // MARK: - Service
    func getIndexList (){

        refreshControl?.beginRefreshing()
        let url = AppTadbirUrl + URLS["IndexListAndDetails"]!
        // Add Headers

        // JSON Body
        let body = IndexDetailsRequest(timeFrameType: TimeFrameType.day, indexCode: "0",language: getAppLanguage()).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (indexs:MainResponse<Response>?, error) in

            if ((indexs?.successful) != nil) {
                self.indexNames.removeAll()
                self.indexCode.removeAll()
                self.indexPrice.removeAll()
                self.indexPercent.removeAll()
                for i in 0  ..< indexs!.response.indexDetailsList.count{
                    self.indexNames.append(indexs!.response.indexDetailsList[i].shortName)
                    self.indexPrice.append(Double(indexs!.response.indexDetailsList[i].closePrice))
                    self.indexPercent.append(indexs!.response.indexDetailsList[i].changePricePercentOnSameTime)
                    self.indexCode.append(indexs!.response.indexDetailsList[i].indexCode)
                    self.tableView.reloadData()
                }
            } else {
                debugPrint(error)
            }

            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == UIConstants.IndexDetailSegue) {

            let indexPath = self.tableView.indexPathForSelectedRow!

            let currentCell = self.tableView.cellForRowAtIndexPath(indexPath)! as! IndexCell

            SelectedIndexCode = String(indexCode[indexPath.row])
            let svc = segue.destinationViewController as! IndexDetailsTabBarController;
            svc.selectedIndexName = currentCell.lblIndexName.text!

        }
    }
    
    override func updateServiceData() {
        getIndexList()
    }

}
