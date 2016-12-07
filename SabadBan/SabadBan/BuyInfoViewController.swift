//
//  BuyInfoViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/18/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import SwiftEventBus
import FCAlertView
import GSMessages

class BuyInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate {

    //MARK : - Properties

    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblCount: UILabel!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnDate: UIButton!

    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnCount: UIButton!

    @IBOutlet weak var btnClose: UIImageView!

    var PsBuyCode = Int()
    var portfolioCode = Int()
    var psBuyData = [psBuyModel]()
    var db = DataBase()
    var myDatePicker: UIDatePicker = UIDatePicker()
    var editMode = Bool()
    var psIdForEdit = Int()
    var price = Float()
    var deleteIndexRow = Int()
    var dialogCurrentString = String()
    var priceAlert = UIAlertController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        editMode = false
        getPsData(PsBuyCode)

    }

    func setupViews() {
        tblHistory.backgroundColor = AppMainColor
        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblHistory.registerNib(UINib(nibName: UIConstants.BuyInfoCell, bundle: nil), forCellReuseIdentifier: UIConstants.buyInfoCells)
        tblHistory.registerNib(UINib(nibName: UIConstants.buyInfoHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.buyInfoHeader)
        tblHistory.tableFooterView = UIView()
        lblDate.text = Strings.Date.localized() + ":"
        lblPrice.text = Strings.Price.localized() + ":"
        lblCount.text = Strings.Count.localized() + ":"
        lblTitle.text = "\(Strings.BuyInformation.localized()) \(SelectedSymbolName)"
        lblTitle.setDefaultFont()
        lblDate.setDefaultFont()
        lblCount.setDefaultFont()
        lblPrice.setDefaultFont()
        btnDate.setTitle("-", forState: .Normal)
        btnPrice.setTitle(price.currencyFormat(0), forState: .Normal)
        btnCount.setTitle("۰", forState: .Normal)
        btnDone.setTitle(Strings.add.localized(), forState: .Normal)
        btnDone.setDefaultFont()
        btnDate.setDefaultFont()
        btnPrice.setDefaultFont()
        btnCount.setDefaultFont()
        PsBuyCode = db.getPsCodeBySymbolCode(String(SelectedSymbolCode), pCode: portfolioCode)

        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.view.insertSubview(blurEffectView, atIndex: 0)

        btnClose.userInteractionEnabled = true
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(self.btnCloseTap))
        btnClose.addGestureRecognizer(closeGesture)
    }

    //MARK:- TableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return psBuyData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.buyInfoCells, forIndexPath: indexPath) as! BuyInfoCell

        cell.lblDate.text = psBuyData[indexPath.row].psDate
        cell.lblCount.text = psBuyData[indexPath.row].psCount.currencyFormat(2)
        cell.lblPrice.text = psBuyData[indexPath.row].psPrice.currencyFormat(2)

        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(BuyInfoViewController.editTaped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(BuyInfoViewController.deleteTaped(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        if indexPath.row % 2 == 0 {
            cell.backgroundLayer.backgroundColor = AppBarTintColor
        } else {
            cell.backgroundLayer.backgroundColor = AppMainColor
        }

        return cell
    }

    func editTaped(sender: UIButton) {

        let indexPath = sender.tag

        if !editMode {
            self.btnDate.setTitle(psBuyData[indexPath].psDate, forState: .Normal)
            self.btnCount.setTitle(psBuyData[indexPath].psCount.currencyFormat(0), forState: .Normal)
            self.btnPrice.setTitle(psBuyData[indexPath].psPrice.currencyFormat(0), forState: .Normal)
            self.btnDone.setTitle(Strings.Edit.localized(), forState: .Normal)
            psIdForEdit = psBuyData[indexPath].psId
            editMode = true
        }

    }

    func deleteTaped(sender: UIButton) {

        deleteIndexRow = sender.tag

        Utils.ShowAlert(self, title: Strings.deleteBuyAlertTitle.localized(), details: Strings.reallyWantToDeleteBuy.localized(), btnOkTitle: Strings.Yes.localized(), btnTitles: [Strings.No.localized()], delegate: self)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.buyInfoHeader) as! BuyInfoHeader

        headerView.lblDate.text = Strings.Date.localized()
        headerView.lblPrice.text = Strings.Price.localized()
        headerView.lblCount.text = Strings.Count.localized()
        headerView.lblDelete.text = Strings.Delete.localized()
        headerView.lblEdit.text = Strings.Edit.localized()

        return headerView
    }

    //MARK:- DB Methods

    func getPsData(psBuyCode: Int) {
        psBuyData = db.getPsBuy(psBuyCode)
        tblHistory.reloadData()
    }

    func AddPsBuy(psBuyCode: Int, price: Double, count: Double, date: String) {

        db.addPsBuy(psBuyCode, price: price, count: count, date: date)
    }

    //MARK:- Buttons Taps
    @IBAction func btnDateTap(sender: AnyObject) {

        DatePickerSheet().show(Strings.SelectDate.localized(), doneButtonTitle: Strings.Ok.localized(), cancelButtonTitle: Strings.Cancel.localized(), datePickerMode: .Date) {
            date -> Void in

            let dateFormat = NSDateFormatter()
            dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle

            dateFormat.timeStyle = NSDateFormatterStyle.NoStyle

            self.btnDate.setTitle(convertToPersianDate(date), forState: .Normal)

            debugPrint(dateFormat.stringFromDate(date))
        }

    }

    @IBAction func btnPriceTap(sender: AnyObject) {

        priceAlert = UIAlertController(title: Strings.Price.localized(), message: "", preferredStyle: .Alert)

        priceAlert.addTextFieldWithConfigurationHandler({
            (textField) -> Void in
            textField.text = self.btnPrice.currentTitle
            textField.keyboardType = .NumberPad
            textField.maxLength = 9
            textField.commaSeperator = true
            textField.allowedCharacter = "0987654321۱۲۳۴۵۶۷۸۹۰"
        })

        priceAlert.addAction(UIAlertAction(title: Strings.Ok.localized(), style: .Default, handler: {
            (action) -> Void in
            let textField = self.priceAlert.textFields![0] as UITextField
            self.btnPrice.setTitle(textField.text, forState: .Normal)
        }))

        self.presentViewController(priceAlert, animated: true, completion: nil)
    }

    @IBAction func btnCountTap(sender: AnyObject) {

        let alert = UIAlertController(title: Strings.Count.localized(), message: "", preferredStyle: .Alert)

        alert.addTextFieldWithConfigurationHandler({
            (textField) -> Void in
            textField.text = self.btnCount.currentTitle
            textField.keyboardType = .NumberPad
            textField.maxLength = 7
            textField.commaSeperator = true
            textField.allowedCharacter = "0987654321۱۲۳۴۵۶۷۸۹۰"
        })

        alert.addAction(UIAlertAction(title: Strings.Ok.localized(), style: .Default, handler: {
            (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.btnCount.setTitle(textField.text, forState: .Normal)
        }))

        self.presentViewController(alert, animated: true, completion: nil)

    }

    @IBAction func btnDoneTap(sender: AnyObject) {

        guard btnDate.currentTitle != "-" else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.enterDatePlease.localized())
            return
        }

        guard btnCount.currentTitle != "" else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.enterQuantityPlease.localized())
            return
        }

        guard btnPrice.currentTitle != "" else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.enterPricePlease.localized())
            return
        }

        let enteredPrice = btnPrice.titleLabel?.text?.getCurrencyNumber()!
        let count = btnCount.titleLabel?.text?.getCurrencyNumber()!
        let date = btnDate.titleLabel?.text

        guard !count!.isEqual(0) else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.enterQuantityPlease.localized())
            return
        }

        guard !enteredPrice!.isEqual(0) else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.enterPricePlease.localized())
            return
        }

        if editMode {
            db.updatePsBuy(psIdForEdit, newPrice: Double(enteredPrice!), newCount: Double(count!), newDate: date!)
            editMode = false

            displayMessage(Strings.buyInfoEdited.localized())

            btnDone.setTitle(Strings.add.localized(), forState: .Normal)
        } else {
            AddPsBuy(PsBuyCode, price: Double(enteredPrice!), count: Double(count!), date: date!)
            displayMessage(Strings.buyInfoAdded.localized())
        }

        btnDate.setTitle("-", forState: .Normal)
        btnCount.setTitle("۰", forState: .Normal)
        btnPrice.setTitle(price.currencyFormat(0), forState: .Normal)
        getPsData(PsBuyCode)

    }

    func displayMessage(message: String) {
        self.showMessage(message, type: .Success, options: [
                .Animation(.Slide),
                .AnimationDuration(0.3),
                .AutoHide(true),
                .AutoHideDelay(3.0),
                .Height(20),
                .HideOnTap(true),
                .Position(.Top),
                .TextAlignment(.Center),
                .TextColor(UIColor.whiteColor()),
                .TextNumberOfLines(1),
                .TextPadding(10)
        ])
    }

    func btnCloseTap() {
        //        SwiftEventBus.postToMainThread("BestBuyClosed", sender: nil)
        SwiftEventBus.post(BestBuyClosed)
        dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK:- AlertView Delegates

    func FCAlertDoneButtonClicked(alertView: FCAlertView) {
        db.deletePsBuy(psBuyData[deleteIndexRow].psId)
        getPsData(PsBuyCode)
        displayMessage(Strings.buyInfoDeleted.localized())
    }
}

struct psBuyModel {
    var psId = Int()
    var psCode = Int()
    var psDate = String()
    var psCount = Double()
    var psPrice = Double()

}
