//
//  BuyInfoViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/18/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import SwiftEventBus
class BuyInfoViewController: BaseViewController ,UITableViewDelegate ,UITableViewDataSource{

    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDate: UIButton!

    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnCount: UIButton!
    var PsBuyCode = Int()
    var portfolioCode = Int()
    var psBuyData = [psBuyModel]()
    var db = DataBase()
    var myDatePicker: UIDatePicker = UIDatePicker()
    var editMode = Bool()
    var psIdForEdit = Int()
    var price = Float()
    override func viewDidLoad() {
        super.viewDidLoad()

        tblHistory.backgroundColor = AppMainColor
        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblHistory.registerNib(UINib(nibName: "BuyInfoCell", bundle: nil), forCellReuseIdentifier: "buyInfoCells")
        tblHistory.registerNib(UINib(nibName: "buyInfoHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "buyInfoHeader")
        tblHistory.tableFooterView = UIView()
        lblDate.text = "Date".localized() + ":"
        lblPrice.text = "Price".localized() + ":"
        lblCount.text = "Count".localized() + ":"
        lblTitle.text = SelectedSymbolName
        btnDate.setTitle("", forState: .Normal)
        btnPrice.setTitle(String(price), forState: .Normal)
        btnCount.setTitle("", forState: .Normal)
        btnDone.setTitle("Submit".localized(), forState: .Normal)
        PsBuyCode = db.getPsCodeBySymbolCode(SelectedSymbolCode, pCode: portfolioCode)
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, atIndex: 0)
        editMode = false
        getPsData(PsBuyCode)

    }

    //MARK:- TableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return psBuyData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("buyInfoCells", forIndexPath: indexPath) as! BuyInfoCell

        cell.lblDate.text = psBuyData[indexPath.row].psDate
        cell.lblCount.text = psBuyData[indexPath.row].psCount.currencyFormat(2)
        cell.lblPrice.text = psBuyData[indexPath.row].psPrice.currencyFormat(2)

        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(BuyInfoViewController.editTaped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(BuyInfoViewController.deleteTaped(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }

    func editTaped(sender:UIButton) {

        let indexPath = sender.tag

        if !editMode {
            self.btnDate.setTitle(psBuyData[indexPath].psDate, forState: .Normal)
            self.btnCount.setTitle(String(psBuyData[indexPath].psCount), forState: .Normal)
            self.btnPrice.setTitle(String(psBuyData[indexPath].psPrice), forState: .Normal)
            self.btnDone.setTitle("Edit".localized(), forState: .Normal)
            psIdForEdit = psBuyData[indexPath].psId
            editMode = true
        }

    }

    func deleteTaped(sender:UIButton) {

        let indexPath = sender.tag

        db.deletePsBuy(psBuyData[indexPath].psId)
        getPsData(PsBuyCode)

    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("buyInfoHeader") as! BuyInfoHeader

        headerView.lblDate.text = "Date".localized()
        headerView.lblPrice.text = "Price".localized()
        headerView.lblCount.text = "Count".localized()
        headerView.lblDelete.text = "Delete".localized()
        headerView.lblEdit.text = "Edit".localized()

        return headerView
    }

    //MARK:- DB Methods

    func getPsData(psBuyCode:Int) {
        psBuyData = db.getPsBuy(psBuyCode)
        tblHistory.reloadData()
    }
    func AddPsBuy(psBuyCode:Int , price : Double , count:Double ,date : String) {

        db.addPsBuy(psBuyCode, price: price, count: count, date: date)
    }

    //MARK:- Buttons Taps
    @IBAction func btnDateTap(sender: AnyObject) {

        DatePickerSheet().show("Select Date", doneButtonTitle: "Ok", cancelButtonTitle: "cancell", datePickerMode: .Date){date -> Void in

            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle

            dateFormat.timeStyle = NSDateFormatterStyle.NoStyle
            self.btnDate.setTitle(dateFormat.stringFromDate(date), forState: .Normal)
            debugPrint(dateFormat.stringFromDate(date))
        }

    }

    @IBAction func btnPriceTap(sender: AnyObject) {

        let alert = UIAlertController(title: "Price".localized(), message: "", preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.keyboardType = .NumberPad
        })

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.btnPrice.setTitle(textField.text, forState: .Normal)
        }))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func btnCountTap(sender: AnyObject) {

        let alert = UIAlertController(title: "Count".localized(), message: "", preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.keyboardType = .NumberPad
        })

        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.btnCount.setTitle(textField.text, forState: .Normal)
        }))

        self.presentViewController(alert, animated: true, completion: nil)

    }

    @IBAction func btnDoneTap(sender: AnyObject) {

        if btnPrice.currentTitle == "" || btnCount.currentTitle == "" || btnDate.currentTitle == "" {
            debugPrint("empty")
        } else {
            let price = Double((btnPrice.titleLabel?.text)!)!
            let count = Double((btnCount.titleLabel?.text)!)!
            let date = btnDate.titleLabel?.text

            if editMode {
                db.updatePsBuy(psIdForEdit, newPrice: price, newCount: count, newDate: date!)
                editMode = false

                btnDone.setTitle("Submit".localized(), forState: .Normal)
            }else {
                AddPsBuy(PsBuyCode, price:price , count: count, date:  date!)
            }

            btnDate.setTitle("", forState: .Normal)
            btnCount.setTitle("", forState: .Normal)
            getPsData(PsBuyCode)
        }
    }

    @IBAction func btnCloseTap(sender: AnyObject) {
//        SwiftEventBus.postToMainThread("BestBuyClosed", sender: nil)
        SwiftEventBus.post("BestBuyClosed")
        dismissViewControllerAnimated(true, completion: nil)
    }

}

struct psBuyModel {
    var psId  = Int()
    var psCode = Int()
    var psDate = String()
    var psCount = Double()
    var psPrice = Double()

}
