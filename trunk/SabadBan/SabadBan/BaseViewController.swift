//
//  BaseViewController.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/20/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import SwiftEventBus
import FCAlertView

class BaseViewController: UIViewController, ENSideMenuDelegate, FCAlertViewDelegate {

    //MARK : - Properties

    var timer: NSTimer?
    static var isNetworkAlertShown = false
    var networkAlert: FCAlertView?
    var timeoutAlert: FCAlertView?
    var serviceUnreachableAlert: FCAlertView?

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) {
            result in
            self.addMenuButton()
        }
        addMenuButton()
        self.setFontFamily(AppFontName_IranSans, forView: self.view, andSubViews: true)
        self.sideMenuController()?.sideMenu?.delegate = self
        self.view.backgroundColor = AppMainColor

        // Do any additional setup after loading the view.

        SwiftEventBus.onMainThread(self, name: NetworkErrorAlert) {
            result in
            if !BaseViewController.isNetworkAlertShown {
                BaseViewController.isNetworkAlertShown = true
                self.networkAlert = Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.noInternet.localized(), delegate: self)
            }

        }
        SwiftEventBus.onMainThread(self, name: TimeOutErrorAlert) {
            result in
            if !BaseViewController.isNetworkAlertShown {
                BaseViewController.isNetworkAlertShown = true
                self.timeoutAlert = Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.ConnectionTimeOut.localized(), delegate: self)
            }
        }

        SwiftEventBus.onMainThread(self, name: ServerErrorAlert) {
            result in
            if !BaseViewController.isNetworkAlertShown {
                BaseViewController.isNetworkAlertShown = true
                self.serviceUnreachableAlert = Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.serviceIsUnreachable.localized())
            }
        }

        timer = NSTimer.scheduledTimerWithTimeInterval(updateServiceInterval, target: self, selector: #selector(BaseViewController.updateServiceData), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addMenuButton() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        let btnMenu = UIButton()
        btnMenu.setImage(UIImage(named: UIConstants.Menu), forState: .Normal)
        btnMenu.frame = CGRectMake(0, 0, 30, 30)
        btnMenu.addTarget(self, action: #selector(openMenu), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == Language.fa.rawValue) {
            let rightBarButton = UIBarButtonItem(customView: btnMenu)
            self.navigationItem.rightBarButtonItem = rightBarButton
        } else {
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

    func updateServiceData() {
    }

    //MARK : - FCAlertView Delegate

    func FCAlertViewDismissed(alertView: FCAlertView!) {
        if (alertView == networkAlert || alertView == timeoutAlert || alertView == serviceUnreachableAlert) {
            BaseViewController.isNetworkAlertShown = false
        }
    }
}
