//
//  NewsSplitViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/7/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class NewsSplitViewController: UISplitViewController ,UISplitViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        self.delegate = self
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return false
        }

            return true
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
