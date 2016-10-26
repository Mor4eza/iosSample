
//
//  BaseTableViewController.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/20/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import SwiftEventBus
class BaseTableViewController: UITableViewController,ENSideMenuDelegate{

    //MARK: Properties
    var timer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) { result in
            self.addMenuButton()
        }
        addMenuButton()
        self.setFontFamily(AppFontName_IranSans, forView: self.view, andSubViews: true)
        self.sideMenuController()?.sideMenu?.delegate = self
        self.tableView.backgroundColor = AppMainColor

        SwiftEventBus.onMainThread(self, name: NetworkErrorAlert) { result in
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.noInternet.localized())
        }
        SwiftEventBus.onMainThread(self, name: TimeOutErrorAlert) { result in
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.ConnectionTimeOut.localized())
        }
        SwiftEventBus.onMainThread(self, name: ServerErrorAlert) { result in
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.serviceIsUnreachable.localized())
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(updateServiceInterval, target: self, selector: #selector(BaseTableViewController.updateServiceData), userInfo: nil, repeats: true)

    }

    func addMenuButton() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        let btnMenu = UIButton()
        btnMenu.setImage(UIImage(named: UIConstants.Menu), forState: .Normal)
        btnMenu.frame = CGRectMake(0, 0, 30, 30)
        btnMenu.addTarget(self, action: #selector(openMenu), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == Language.fa.rawValue){
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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        SwiftEventBus.unregister(self)
        invalidTimer()
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
    
    func updateServiceData() {
    }
    
    func invalidTimer() {
        if let mTimer = timer {
            mTimer.invalidate()
        }
    }

    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
    }

    func sideMenuWillClose() {
    }

    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }

    func sideMenuDidClose() {
    }

    func sideMenuDidOpen() {
    }

}
