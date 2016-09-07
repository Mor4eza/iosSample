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
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsetsMake(64.0, 0, 0, 0) //
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.scrollsToTop = false
    
        // Preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CELL")
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
            cell!.backgroundColor = UIColor.clearColor()
            cell!.textLabel?.textColor = UIColor.darkGrayColor()
            let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
            selectedBackgroundView.tintColor = UIColor.redColor()
            cell!.selectedBackgroundView = selectedBackgroundView
            
        }
        
        switch indexPath.row {
        case 0:
            cell?.textLabel?.text = "Index".localized()
            break
        case 1:
            cell?.textLabel?.text = "Portfolio".localized()
            break
        case 2:
             cell?.textLabel?.text = "Setting".localized()
            break
        case 3:
            cell?.textLabel?.text = "AboutUs".localized()
            break
        case 4:
            cell?.textLabel?.text = "ContactUs".localized()
            break
        default:
            cell?.textLabel?.text = "Empty".localized()
            break
        }
        
            cell?.textLabel?.changeDirection()
    
        
        return cell!
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
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("settingViewController")
            break
        case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AboutUsViewController")
            break
        case 4:
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
