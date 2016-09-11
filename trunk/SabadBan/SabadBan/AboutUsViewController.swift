//
//  AboutUsViewController.swift
//  SabadBan
//
//  Created by PC22 on 9/11/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Localize_Swift

class AboutUsViewController: BaseViewController {
    
    //MARK: Properties

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var updateIntervalNoticeLabel: UILabel!
    @IBOutlet weak var allRightsReserevedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        versionLabel.text = "\("Version".localized() + " " +  String(NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String))"
        
        updateIntervalNoticeLabel.text = "UpdateDataIntervalNotice".localized()
        allRightsReserevedLabel.text = "AllrightsReserved".localized()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
