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
        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) { result in
            self.initMenu()
        }
        var menuPosition:ENSideMenuPosition!
        
        if getAppLanguage() == "fa"{
            menuPosition = ENSideMenuPosition.Right
        }else {
            menuPosition = ENSideMenuPosition.Left
        }
        
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: MyMenuTableViewController(), menuPosition: menuPosition,blurStyle: .ExtraLight)
        
        sideMenu?.animationDuration = 0.24
        sideMenu?.menuWidth = 280 // optional, default is 160
        sideMenu?.bouncingEnabled = false
        sideMenu?.allowPanGesture = true
        if getAppLanguage() == "en" {
            sideMenu?.showSideMenu()
            sideMenu?.hideSideMenu()
        }
        
        view.bringSubviewToFront(navigationBar)
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ENSideMenu Delegate
    
    func initMenu(){
        var menuPosition:ENSideMenuPosition!
        if getAppLanguage() == "fa"{
            menuPosition = ENSideMenuPosition.Right
        }else {
            menuPosition = ENSideMenuPosition.Left
        }
        sideMenu?.menuPosition = menuPosition
        sideMenu?.showSideMenu()
        sideMenu?.hideSideMenu()
    }
    
    func addMenuButton() {
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "Menu"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(openMenu), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == "fa"){
            let rightBarButton = UIBarButtonItem(customView: btnName)
            self.navigationItem.rightBarButtonItem = rightBarButton
        }else {
            let rightBarButton = UIBarButtonItem(customView: btnName)
            self.navigationItem.leftBarButtonItem = rightBarButton
        }
    }
    func openMenu() {
        self.toggleSideMenuView()
    }
    
}
