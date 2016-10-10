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
class BaseViewController: UIViewController,ENSideMenuDelegate {
    
    var timer : NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()

        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) { result in
            self.addMenuButton()
        }
        addMenuButton()
        self.setFontFamily(AppFontName_IranSans, forView: self.view, andSubViews: true)

        self.view.backgroundColor = AppMainColor

        // Do any additional setup after loading the view.

        SwiftEventBus.onMainThread(self, name: NetworkErrorAlert) { result in
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.noInternet.localized())
        }
        SwiftEventBus.onMainThread(self, name: TimeOutErrorAlert) { result in
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.ConnectionTimeOut.localized())
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: #selector(BaseViewController.updateServiceData), userInfo: nil, repeats: true)
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
        if let mTimer = timer{
            mTimer.invalidate()
        }
        
    }

    func updateServiceData() {
    }
}
