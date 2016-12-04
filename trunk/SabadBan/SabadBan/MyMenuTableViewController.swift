//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by morteza Gharedaghi on 8/16/16.
//  Copyright © 2016 Morteza Gharedaghi. All rights reserved.//
//

import UIKit
import Localize_Swift

class MyMenuTableViewController: BaseTableViewController {
    var selectedMenuItem: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: UIConstants.menuCell, bundle: nil), forCellReuseIdentifier: UIConstants.menuCells)
        tableView.registerNib(UINib(nibName: UIConstants.menuHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.menuHeader)

        self.tableView.tableFooterView = UIView()

        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        tableView.bounces = false
        
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.menuHeader) as! menuHeader

        if isGuest == true {
            headerView.lblUserName.text = Strings.GuestUser.localized()
            headerView.lblUserName.setDefaultFont(18)
            headerView.lblUserName.changeDirection()
        } else {
            headerView.lblUserName.text = LogedInUserName
        }
        return headerView
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 6
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.menuCells
                , forIndexPath: indexPath) as! menuCell

        cell.backgroundColor = UIColor.clearColor()
        cell.lblMenuName?.textColor = UIColor.darkGrayColor()
        let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
        selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        selectedBackgroundView.tintColor = UIColor.redColor()
        cell.selectedBackgroundView = selectedBackgroundView
        cell.selectionStyle = .None

        switch indexPath.row {
        case 0:
            cell.lblMenuName?.text = Strings.Index.localized()
            cell.imgMenu.image = UIImage(named: UIConstants.index)
            break
        case 1:
            cell.lblMenuName?.text = Strings.Portfolio.localized()
            cell.imgMenu.image = UIImage(named: UIConstants.portfolio)
            break
        case 2:
            cell.lblMenuName?.text = Strings.News.localized()
            cell.imgMenu.image = UIImage(named: UIConstants.NewsImg)
            break
        case 3:
            cell.lblMenuName?.text = Strings.ContactUs.localized()
            cell.imgMenu.image = UIImage(named: UIConstants.contactUs)
            break
        case 4:
            cell.lblMenuName?.text = Strings.AboutUs.localized()
            cell.imgMenu.image = UIImage(named: UIConstants.aboutUs)
            break
        default:
            cell.lblMenuName?.text = Strings.Exit.localized()
            cell.imgMenu.image = UIImage(named: UIConstants.exit)
            break
        }

        cell.lblMenuName?.changeDirection()

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        debugPrint("did select row: \(indexPath.row)")

        //        if (indexPath.row == selectedMenuItem) {
        //            return
        //        }

        selectedMenuItem = indexPath.row

        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: UIConstants.Main, bundle: nil)
        var destViewController: UIViewController?
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.indexTableViewController)
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.PortfolioViewController)
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.NewsTabBarController)
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.ContactUsViewController)
            break
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.AboutUsViewController)
            break
        case 5:
            logOutService()
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.LogInViewController)

            // self.presentViewController(destViewController!, animated: true, completion: nil)

            return
        }
        if destViewController != nil {
            sideMenuController()?.setContentViewController(destViewController!)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(setTexts), name: LCLLanguageChangeNotification, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func setTexts() {
        self.tableView.reloadData()
    }

    func logOutService() {
        let url = AppNewsURL + URLS["logout"]!

        // JSON Body
        let body = LogoutRequest(apiToken: LoginToken).getDic()

        // Fetch Request
        Request.postData(url, body: body) {
            (response: UserManagementModel<LoginResponse>?, error) in

            self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)
            let mainStoryboard: UIStoryboard = UIStoryboard(name: UIConstants.Main, bundle: nil)
            let destViewController = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.LogInViewController)
            self.presentViewController(destViewController, animated: true, completion: nil)

        }

    }

}
