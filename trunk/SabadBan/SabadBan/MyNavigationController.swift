//
//  MyNavigationController.swift
//  SwiftSideMenu
//
//  Created by morteza Gharedaghi on 8/16/16.
//  Copyright © 2016 Morteza Gharedaghi. All rights reserved.//

import UIKit
import Localize_Swift
import SwiftEventBus

public class MyNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {

    override public func viewDidLoad() {
        super.viewDidLoad()
        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) {
            result in
            print("getMessage")
            self.initMenu()
        }
        self.navigationBar.setTitleFont(with: UIColor.whiteColor())
        var menuPosition: ENSideMenuPosition!

        if getAppLanguage() == Language.fa.rawValue {
            menuPosition = ENSideMenuPosition.Right
        } else {
            menuPosition = ENSideMenuPosition.Left
        }

        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MyMenuTableViewController(), menuPosition: menuPosition, blurStyle: .ExtraLight)

        sideMenu?.animationDuration = 0.24
        sideMenu?.menuWidth = 280 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        sideMenu?.allowPanGesture = true
        if getAppLanguage() == Language.en.rawValue {
            sideMenu?.showSideMenu()
            sideMenu?.hideSideMenu()
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ENSideMenu Delegate

    func initMenu() {
        var menuPosition: ENSideMenuPosition!
        if getAppLanguage() == Language.fa.rawValue {
            menuPosition = ENSideMenuPosition.Right
            sideMenu?.outterView.frame = CGRectMake(0, 0, self.view.frame.width - 280, self.view.frame.height)
        } else {
            menuPosition = ENSideMenuPosition.Left
            sideMenu?.outterView.frame = CGRectMake(280, 0, self.view.frame.width, self.view.frame.height)

        }
        sideMenu?.menuPosition = menuPosition

        sideMenu?.showSideMenu()
        sideMenu?.hideSideMenu()
        SwiftEventBus.unregister(self)
    }

    func addMenuButton() {
        let btnName = UIButton()
        btnName.setImage(UIImage(named: UIConstants.Menu), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(openMenu), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == Language.fa.rawValue) {
            let rightBarButton = UIBarButtonItem(customView: btnName)
            self.navigationItem.rightBarButtonItem = rightBarButton
        } else {
            let rightBarButton = UIBarButtonItem(customView: btnName)
            self.navigationItem.leftBarButtonItem = rightBarButton
        }
    }

    func openMenu() {
        self.toggleSideMenuView()
    }

}
