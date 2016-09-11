//
//  BourseNewsTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/7/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class BourseNewsTableViewController: BaseTableViewController ,ENSideMenuDelegate {
    
    var newsModel = [NewsModel]()
    var newsCount = 0
    var servicePage = 0
    var isMore = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addMenuButton()
        isMore = true
        refreshControl = UIRefreshControl()
        //        refreshControl!.attributedTitle = attrText
        refreshControl!.tintColor = UIColor.whiteColor()
        refreshControl!.addTarget(self, action: #selector(DetailsViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        sendBourseNewsRequest(servicePage)
    }
    
    func refresh(sender:AnyObject) {
        sendBourseNewsRequest(servicePage)
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
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row + 1  >= newsCount {
            sendBourseNewsRequest(servicePage)
        }
        
    }
    
    
    //MARK:- get Bourse News Service
    func sendBourseNewsRequest(page:Int) {
        refreshControl?.beginRefreshing()
        
        
        
        if isMore{
            debugPrint("page : \(page)")
            let url = AppNewsURL + URLS["getBourseNews"]!
            // Add Headers
            let headers = [
                "Content-Type":"application/json",
                ]
            
            let body = [
                "take":10,
                "api_token": "VyKMDnGUy3lWSICVbPN9GiO019GP6DuDzpKWxofdNSg4HPnf6Gf1jgixvD1G",
                "page": page
            ]
            // Fetch Request
            Alamofire.request(.POST,url, headers: headers, parameters: body as? [String : AnyObject] , encoding: .JSON)
                .validate(statusCode: 200..<300)
                .responseObjectErrorHadling(MainResponse<BourseNewsResponse>.self) { response in
                    
                    switch response.result {
                    case .Success(let news):
                        for i in 0..<news.response.newsDetailsList.count {
                            self.newsModel.append(NewsModel(title: news.response.newsDetailsList[i].title, details: news.response.newsDetailsList[i].descriptionField, date: news.response.newsDetailsList[i].createdAt,link: news.response.newsDetailsList[i].reference))
                        }
                        self.newsCount += news.response.count
                        self.servicePage += 1
                        
                        debugPrint(" news.response.count : \( news.response.count)")
                        
                        if (news.response.count) > 0 {
                            
                            self.isMore = true
                        }else {
                            self.isMore = false
                        }
                        self.tableView.reloadData()
                    case .Failure(let error):
                        debugPrint(error)
                    }
            }
        }
        self.refreshControl?.endRefreshing()
        
    }
    
    //MARK:- Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if (segue.identifier == "NewsDetailsSeguei") {
            
            let index = self.tableView.indexPathForSelectedRow!
            let svc = segue.destinationViewController as! NewsDetailViewController
            
            svc.newsTitle = newsModel[index.row].title
            svc.newsDetails = newsModel[index.row].details
            svc.newsDate = newsModel[index.row].date
            svc.newsLink = newsModel[index.row].link
            
        }
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return false
    }
}

