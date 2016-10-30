//
//  OurInfoViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/2/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class OurInfoViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = Strings.ContactInfo.localized()

        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func closeTaped(sender: AnyObject) {

        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
