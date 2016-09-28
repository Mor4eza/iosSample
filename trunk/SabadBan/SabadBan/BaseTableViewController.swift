
//
//  BaseTableViewController.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/20/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import SwiftEventBus
class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) { result in
            self.addMenuButton()
        }
        addMenuButton()
        self.setFontFamily(AppFontName_IranSans, forView: self.view, andSubViews: true)
        self.tableView.backgroundColor = AppMainColor
        // Do any additional setup after loading the view.
    }

    func addMenuButton() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        let btnMenu = UIButton()
        btnMenu.setImage(UIImage(named: "Menu"), forState: .Normal)
        btnMenu.frame = CGRectMake(0, 0, 30, 30)
        btnMenu.addTarget(self, action: #selector(openMenu), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == "fa"){
            let rightBarButton = UIBarButtonItem(customView: btnMenu)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }else {
            let rightBarButton = UIBarButtonItem(customView: btnMenu)
            self.navigationItem.leftBarButtonItem = rightBarButton
        }
    }
    func openMenu() {
        self.toggleSideMenuView()
    }

    // MARK: - TableView Delegates
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.font = UIFont(name: AppFontName_IranSans, size: (cell.textLabel?.font.pointSize)!)
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if (view is UILabel){
            let lable = (view as! UILabel)
            lable.font = UIFont(name: AppFontName_IranSans, size: (lable.font.pointSize))
        }
    }
}
