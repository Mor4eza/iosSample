//
//  SymbolDetailsTabBar.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/27/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class SymbolDetailsTabBar: UITabBarController {
    
    //MARK : - Properties
    var hasComeFromPush = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(netHex: 0x172340)

        self.title = SelectedSymbolName
        addMenuButton()
        // Do any additional setup after loading the view.
        
        if hasComeFromPush {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: UIConstants.icBack), style: .Plain, target: self, action: #selector(self.goToPortfolio))
        }
    }

    func addMenuButton() {
        
        self.navigationItem.rightBarButtonItem = nil
        
        if !hasComeFromPush {
            self.navigationItem.leftBarButtonItem = nil
        }

        let alarmButton = UIButton()
        alarmButton.setImage(UIImage(named: UIConstants.Alarm), forState: .Normal)
        alarmButton.frame = CGRectMake(0, 0, 30, 30)
        alarmButton.addTarget(self, action: #selector(openAlarmView), forControlEvents: .TouchUpInside)
        let alarmBarButton = UIBarButtonItem(customView: alarmButton)


        //.... Set Right/Left Bar Button item
        if (getAppLanguage() == Language.fa.rawValue) {
            self.navigationItem.rightBarButtonItem = alarmBarButton
        } else {
            self.navigationItem.leftBarButtonItem = alarmBarButton
        }
    }

    func openAlarmView() {
        let mainStoryBoard = UIStoryboard(name: UIConstants.Main, bundle: nil)
        let alarmVC = mainStoryBoard.instantiateViewControllerWithIdentifier(UIConstants.AlarmFilterViewController)
        alarmVC.modalPresentationStyle = .OverFullScreen
        alarmVC.modalTransitionStyle = .CrossDissolve
        presentViewController(alarmVC, animated: true, completion: nil)
    }

    func openMenu() {
        self.toggleSideMenuView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToPortfolio() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: UIConstants.Main, bundle: nil)
        let portfolioVC = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.PortfolioViewController) as! PortfolioListViewController
        let myNav = MyNavigationController(menuViewController: MyMenuTableViewController(), contentViewController: portfolioVC)
        //                myNav.viewDidLoad()
        appdelegate.window!.rootViewController = myNav
    }

}
