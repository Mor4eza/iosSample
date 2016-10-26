//
//  BourseNewsTableViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/7/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
class BourseNewsTableViewController: BaseTableViewController {

    var newsModel = [NewsModel]()
    var newsCount = 0
    var servicePage = 0
    var isMore = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        super.addMenuButton()
        isMore = true
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.whiteColor()
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height)

        refreshControl!.addTarget(self, action: #selector(BourseNewsTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
        sendBourseNewsRequest(servicePage)
    }

    func refresh(sender:AnyObject) {
        updateServiceData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.ObserverNewsCell, forIndexPath: indexPath) as! NewsCell

        cell.lblNewsTitle.text = newsModel[indexPath.row].title
        cell.lblNewsDetails.text = newsModel[indexPath.row].details
        cell.lblNewsDate.text = newsModel[indexPath.row].date

        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clearColor()
        cell.selectedBackgroundView = backgroundView

        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        if (indexPath.row + 1  >= newsCount && newsCount != 0) {
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

            let body = BourseNewsRequest(take: 10, api_token: LoginToken, page: page).getDic()

            // Fetch Request
            Request.postData(url, body: body) { (news:NewsMainResponse<BourseNewsResponse>?, error) in
                if ((news?.success) != nil) {
                    if page == 0 {
                        self.newsModel.removeAll()
                        self.tableView.reloadData()
                    }
                    for i in 0..<news!.response.newsDetailsList.count {
                        let date = self.convertStringToDate(news!.response.newsDetailsList[i].createdAt)
                        let dateString = convertToPersianDateWithTime(date)
                        
                        self.newsModel.append(NewsModel(title: news!.response.newsDetailsList[i].title, details: news!.response.newsDetailsList[i].descriptionField, date: dateString,link: news!.response.newsDetailsList[i].reference))
                    }
                    self.newsCount += news!.response.count
                    self.servicePage += 1

                    if (news!.response.count) > 0 {

                        self.isMore = true
                    }else {
                        self.isMore = false
                    }
                    self.tableView.reloadData()
                } else {
                    debugPrint(error)
                }
            }
        }
        self.refreshControl?.endRefreshing()

    }

    //MARK:- Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if (segue.identifier == UIConstants.NewsDetailsSeguei) {

            let index = self.tableView.indexPathForSelectedRow!
            let svc = segue.destinationViewController as! NewsDetailViewController

            svc.newsTitle = newsModel[index.row].title
            svc.newsDetails = newsModel[index.row].details
            svc.newsDate = newsModel[index.row].date
            svc.newsLink = newsModel[index.row].link

        }
    }

    override func sideMenuShouldOpenSideMenu() -> Bool {
        return false
    }
    
    override func updateServiceData() {
        servicePage = 0
        newsCount = 0
        isMore = true
        sendBourseNewsRequest(servicePage)
    }
    
    func convertStringToDate(dateString: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.dateFromString(dateString)!
    }
}
