//
//  BuyInfoViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/18/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class BuyInfoViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    
    @IBOutlet weak var btnDate: UIButton!

    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnCount: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        tblHistory.backgroundColor = AppMainColor
        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblHistory.registerNib(UINib(nibName: "BuyInfoCell", bundle: nil), forCellReuseIdentifier: "buyInfoCells")
        tblHistory.registerNib(UINib(nibName: "buyInfoHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "buyInfoHeader")
        
        let blurEffect = UIBlurEffect(style: .Dark)
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
    
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, atIndex: 0)
        
        
    }

    
    
    //MARK:- TableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("buyInfoCells", forIndexPath: indexPath) as! BuyInfoCell
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("buyInfoHeader") as! BuyInfoHeader
        
        return headerView
    }
    

    
    @IBAction func btnDateTap(sender: AnyObject) {
    }
    
    @IBAction func btnPriceTap(sender: AnyObject) {
    }
    
    @IBAction func btnCountTap(sender: AnyObject) {
    }
    

   
    @IBAction func btnCloseTap(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }


}
