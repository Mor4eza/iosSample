//
//  BaseViewController.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/20/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import SwiftEventBus
class BaseViewController: UIViewController,ENSideMenuDelegate,DialogClickDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftEventBus.onMainThread(self, name: LanguageChangedNotification) { result in
            self.addMenuButton()
        }
        addMenuButton()
        self.setFontFamily(AppFontName_IranSans, forView: self.view, andSubViews: true)

        self.view.backgroundColor = AppMainColor

//        let fontFamilyNames = UIFont.familyNames()
//        for familyName in fontFamilyNames {
//            print("------------------------------")
//            print("Font Family Name = [\(familyName)]")
//            let names = UIFont.fontNamesForFamilyName(familyName)
//            print("Font Names = [\(names)]")
//        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        SwiftEventBus.unregister(self)
    }
    
    func dialogOkButtonClicked(){
        
    }
    
    func dialogCancelButtonClicked(){
    
    }
}
