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
    var selectedMenuItem : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCells")
        tableView.registerNib(UINib(nibName: "menuHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "menuHeader")
        
        self.tableView.tableFooterView = UIView()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
        tableView.bounces = false
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }


    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("menuHeader") as! menuHeader
        
        headerView.lblUserName.text = LogedInUserName
        
        return headerView
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 7
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCells", forIndexPath: indexPath) as! menuCell
        
        
            cell.backgroundColor = UIColor.clearColor()
            cell.lblMenuName?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            selectedBackgroundView.tintColor = UIColor.redColor()
            cell.selectedBackgroundView = selectedBackgroundView
            
        
        
        switch indexPath.row {
        case 0:
            cell.lblMenuName?.text = "Index".localized()
            cell.imgMenu.image = UIImage(named: "index")
            break
        case 1:
            cell.lblMenuName?.text = "Portfolio".localized()
            cell.imgMenu.image = UIImage(named: "portfolio")
            break
        case 2:
            cell.lblMenuName?.text = "News".localized()
            cell.imgMenu.image = UIImage(named: "News-100")
            break
        case 3:
             cell.lblMenuName?.text = "Setting".localized()
             cell.imgMenu.image = UIImage(named: "setting")
            break
        case 4:
            cell.lblMenuName?.text = "AboutUs".localized()
            cell.imgMenu.image = UIImage(named: "aboutUs")
            break
        case 5:
            cell.lblMenuName?.text = "ContactUs".localized()
            cell.imgMenu.image = UIImage(named: "contactUs")
            break
        default:
            cell.lblMenuName?.text = "Exit".localized()
            cell.imgMenu.image = UIImage(named: "exit")
            break
        }
        
            cell.lblMenuName?.changeDirection()
    
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("did select row: \(indexPath.row)")
        
        if (indexPath.row == selectedMenuItem) {
            return
        }
        
        selectedMenuItem = indexPath.row
        
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        switch (indexPath.row) {
        case 0:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("indexTableViewController")
            break
        case 1:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("PortfolioViewController")
            break
        case 2:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("NewsTabBarController")
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("settingViewController")
            break
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AboutUsViewController")
            break
        case 5:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController4") 
            break
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("viewController5")
            break
        }
        sideMenuController()?.setContentViewController(destViewController)
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

}
