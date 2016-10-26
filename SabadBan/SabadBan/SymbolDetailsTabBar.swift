//
//  SymbolDetailsTabBar.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/27/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class SymbolDetailsTabBar:UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex: 0x172340)

        self.title = SelectedSymbolName
        addMenuButton()
        // Do any additional setup after loading the view.
    }
    func addMenuButton() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil

        let alarmButton = UIButton()
        alarmButton.setImage(UIImage(named: UIConstants.Alarm), forState: .Normal)
        alarmButton.frame = CGRectMake(0, 0, 30, 30)
        alarmButton.addTarget(self, action: #selector(openAlarmView), forControlEvents: .TouchUpInside)
        let alarmBarButton = UIBarButtonItem(customView: alarmButton)

        let btnMenu = UIButton()
        btnMenu.setImage(UIImage(named: UIConstants.Menu), forState: .Normal)
        btnMenu.frame = CGRectMake(0, 0, 30, 30)
        btnMenu.addTarget(self, action: #selector(openMenu), forControlEvents: .TouchUpInside)
        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == Language.fa.rawValue){
            let rightBarButton = UIBarButtonItem(customView: btnMenu)
            self.navigationItem.rightBarButtonItem = rightBarButton
            self.navigationItem.rightBarButtonItem = alarmBarButton
        }else {
            let rightBarButton = UIBarButtonItem(customView: btnMenu)
            self.navigationItem.leftBarButtonItem = rightBarButton
            self.navigationItem.leftBarButtonItem = alarmBarButton
        }
    }

    func openAlarmView() {
        self.performSegueWithIdentifier(UIConstants.AlarmSegue, sender: nil)
    }

    func openMenu() {
        self.toggleSideMenuView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
