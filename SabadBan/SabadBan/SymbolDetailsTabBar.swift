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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
