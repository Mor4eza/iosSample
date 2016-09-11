//
//  NewsTabBarController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/10/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class NewsTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenuButton()
        // Do any additional setup after loading the view.
        self.title = "News".localized()
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
    
}
