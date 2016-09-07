//
//  MarketAssistantTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/7/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class ObserverNewsTableViewController: BaseTableViewController , UISplitViewControllerDelegate {
    
    var newsModel = [NewsModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
        refreshControl = UIRefreshControl()
        //        refreshControl!.attributedTitle = attrText
        refreshControl!.tintColor = UIColor.whiteColor()
        refreshControl!.addTarget(self, action: #selector(DetailsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        sendObserverNewsRequest()
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
        }else {
            self.clearsSelectionOnViewWillAppear = true
        }
        splitViewController?.delegate = self
    }
    func refresh(sender:AnyObject) {
        sendObserverNewsRequest()
    }
    
    
    
    func splitViewController(svc: UISplitViewController, shouldHideViewController vc: UIViewController, inOrientation orientation: UIInterfaceOrientation) -> Bool {
        return false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ObserverNewsCell", forIndexPath: indexPath) as! NewsCell
        
        cell.lblNewsTitle.text = newsModel[indexPath.row].title
        cell.lblNewsDetails.text = newsModel[indexPath.row].details
        cell.lblNewsDate.text = newsModel[indexPath.row].date
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    
    //MARK:- get Observer news Service
    func sendObserverNewsRequest() {
        /**
         News
         POST http://185.37.52.193:9090/services/getNewsListAndDetails
         */
        
        refreshControl?.beginRefreshing()
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json",
            ]
        
        let date = NSDate();
        // "Apr 1, 2015, 8:53 AM" <-- local without seconds
        
        let formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        let time = formatter.stringFromDate(date);
      
        debugPrint(time)
        // JSON Body
        let body = [
            "newsStartTime": time,
            "symbolCodeList": [
                
            ]
        ]
        
        // Fetch Request
        Alamofire.request(.POST, "http://185.37.52.193:9090/services/getNewsListAndDetails", headers: headers, parameters: body as? [String : AnyObject], encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(MainResponse<ObserverNewsResponse>.self) { response in
                
                switch response.result {
                case .Success(let news):
                    
                    for i in 0..<news.response.newsDetailsList.count {
                        self.newsModel.append(NewsModel(title: news.response.newsDetailsList[i].newsTitle, details: news.response.newsDetailsList[i].newsReport, date: news.response.newsDetailsList[i].newsTime))
                    }
                    self.tableView.reloadData()
                case .Failure(let error):
                    debugPrint(error)
                }
                self.refreshControl?.endRefreshing()
        }
        
        
    }
}

struct NewsModel {
    var title = String()
    var details = String()
    var date = String()
}
