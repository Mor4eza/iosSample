//
//  AlarmFilterViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import FCAlertView

class AlarmFilterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, FCAlertViewDelegate {
    
    //MARK: Properties
    
    @IBOutlet var swType: Switch!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblType: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnPrice: UIButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var tblHistory: UITableView!
    
    var priceAlert = UIAlertController()
    var alarmData = [AlarmsData]()
    var editMode = Bool()
    var selectedRowEdit = Int()
    var selectedRowDelete = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        getAlarms(LogedInUserName, symbolCode: SelectedSymbolCode)
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        
        tblHistory.backgroundColor = AppMainColor
        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblHistory.registerNib(UINib(nibName: UIConstants.alarmDataCell, bundle: nil), forCellReuseIdentifier: UIConstants.alarmDataCell)
        tblHistory.registerNib(UINib(nibName: UIConstants.alarmFilterHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.alarmFilterHeader)
        
        lblTitle.text = Strings.sellOrBuyAlarm.localized()
        lblTitle.setDefaultFont()
        lblType.text = Strings.kind.localized()
        lblPrice.text = Strings.Price.localized()
        resetView()
        lblType.setDefaultFont()
        btnPrice.setDefaultFont()
        lblPrice.setDefaultFont()
        btnAdd.setDefaultFont()
    }
    
    //MARK:- TableView Delegates
    
    //MARK:- TableView Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.alarmDataCell, forIndexPath: indexPath) as! AlarmDataCell
        cell.lblPrice.text = alarmData[indexPath.row].alarmPrice.currencyFormat(2)
        let type = alarmData[indexPath.row].orderType
        
        if type == OrderType.Buy.rawValue {
            cell.lblType.textColor = UIColor.greenColor()
            cell.lblType.text = Strings.buy.localized()
        } else {
            cell.lblType.textColor = UIColor.redColor()
            cell.lblType.text = Strings.sell.localized()
        }
        let active: Bool = alarmData[indexPath.row].active
        if active {
            cell.btnEdit.hidden = false
            cell.lblSymbol.text = Strings.notSended.localized()
        } else {
            cell.btnEdit.hidden = true
            cell.lblSymbol.text = Strings.sended.localized()
        }
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(AlarmFilterViewController.editTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(AlarmFilterViewController.deleteTap(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(UIConstants.alarmFilterHeader) as! AlarmDataHeader
        
        headerView.lblType.text = Strings.kind.localized()
        headerView.lblPrice.text = Strings.Price.localized()
        headerView.lblSymbol.text = Strings.status.localized()
        headerView.lblDelete.text = Strings.Delete.localized()
        headerView.lblEdit.text = Strings.Edit.localized()
        
        return headerView
    }
    
    //MARK:- WebServices
    
    func getAlarms(email: String, symbolCode: Int64) {
        
        LoadingOverlay.shared.showOverlay(self.view)
        
        let url = AppTadbirUrl + URLS["getAlarmFiltersBySymbol"]!
        
        // JSON Body
        let body = FindAlarmsRequest(email: email, symbolCode: symbolCode).getDic()
        
        // Fetch Request
        Request.postData(url, body: body) {
            (alarms: MainResponse<AlarmResponse>?, error) in
            if ((alarms?.successful) != nil) {
                if alarms!.response.alarmFilterList.count > 0 {
                    self.alarmData.removeAll()
                    for alarm in alarms!.response.alarmFilterList {
                        self.alarmData.append(AlarmsData(active: alarm.active,
                            alarmPrice: alarm.alarmPrice,
                            atPrice: alarm.atPrice,
                            descriptionField: alarm.descriptionField,
                            id: alarm.id,
                            orderType: alarm.orderType,
                            priceDirection: alarm.priceDirection,
                            symbolCode: alarm.symbolCode))
                    }
                    self.tblHistory.reloadData()
                }
                
            } else {
                debugPrint(error)
            }
            LoadingOverlay.shared.hideOverlayView()
        }
        
    }
    
    func addAlarm(email: String, atPrice: Double, alarmPrice: Double, orderType: String) {
        
        LoadingOverlay.shared.showOverlay(self.view)
        
        let url = AppTadbirUrl + URLS["addAlarmFilter"]!
        
        // JSON Body
        let body = AddAlarmRequest(email: email, symbolCode: SelectedSymbolCode, atPrice: SelectedSymbolLastTradePrice, orderType: orderType, alarmPrice: alarmPrice, description: "", active: true).getDic()
        
        // Fetch Request
        Request.postData(url, body: body) {
            (alarms: MainResponse<AddAlarmResponse>?, error) in
            
            guard (alarms?.successful != nil) else {
                return
            }
            
            
            if alarms?.response != nil {
                self.btnPrice.setTitle(SelectedSymbolLastTradePrice.currencyFormat(0), forState: .Normal)
                self.getAlarms(LogedInUserName, symbolCode: SelectedSymbolCode)
            } else {
                if alarms?.errorCode != nil {
                    if (alarms?.errorCode)! == duplicateAlarmErrorCode {
                        Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.duplicateAlarm.localized())
                    }
                }
            }
            LoadingOverlay.shared.hideOverlayView()
        }
        
    }
    
    func deleteAlarm(id: Int, email: String) {
        
        LoadingOverlay.shared.showOverlay(self.view)
        
        let url = AppTadbirUrl + URLS["deleteAlarmFilter"]!
        
        // JSON Body
        let body = DeleteAlarmRequest(id: id, email: email).getDic()
        
        // Fetch Request
        Request.postData(url, body: body) {
            (alarms: MainResponse<AddAlarmResponse>?, error) in
            
            guard (alarms?.successful != nil) else {
                return
            }
            
            if (alarms!.successful!) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.showMessage("alarmIsDeleted", type: .Success, options: [
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
                
                self.getAlarms(LogedInUserName, symbolCode: SelectedSymbolCode)
                
                self.editMode = false
                self.resetView()
                
            } else {
                if alarms?.errorCode != nil {
                    if (alarms?.errorCode)! == duplicateAlarmErrorCode {
                        Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.duplicateAlarm.localized())
                        return
                    }
                }
                
            }
            LoadingOverlay.shared.hideOverlayView()
        }
    }
    
    func editAlarm(id: Int, email: String, atPrice: Double, alarmPrice: Double, orderType: String) {
        
        LoadingOverlay.shared.showOverlay(self.view)
        
        let url = AppTadbirUrl + URLS["editAlarmFilter"]!
        
        // JSON Body
        let body = EditAlarmRequest(id: id, email: LogedInUserName, symbolCode: SelectedSymbolCode, atPrice: SelectedSymbolLastTradePrice, orderType: orderType, alarmPrice: alarmPrice, description: "", active: true).getDic()
        
        // Fetch Request
        Request.postData(url, body: body) {
            (alarms: MainResponse<EditAlarmResponse>?, error) in
            
            guard (alarms?.successful != nil) else {
                return
            }
            
            if (alarms!.successful!) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.showMessage("alarmEditedSuccessfully", type: .Success, options: [
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
                self.getAlarms(LogedInUserName, symbolCode: SelectedSymbolCode)
                
            } else {
                if alarms?.errorCode != nil {
                    if (alarms?.errorCode)! == duplicateAlarmErrorCode {
                        Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.duplicateAlarm.localized())
                    }
                }
            }
            
            self.editMode = false
            self.resetView()
            LoadingOverlay.shared.hideOverlayView()
            
        }
    }
    
    //MARK:- Actions
    
    @IBAction func btnCloseTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnAddTap(sender: AnyObject) {
        
        guard ((btnPrice.currentTitle) != "") else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.enterPricePlease.localized())
            return
        }
        
        guard (btnPrice.currentTitle?.getCurrencyNumber() != SelectedSymbolLastTradePrice) else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.priceShouldntBeLastTrade.localized())
            return
        }
        
        guard (alarmData.count < 20) else {
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.alarmCountAlert.localized())
            return
        }
        
        guard (btnPrice.currentTitle != nil) else {
            return
        }
        
        let price = Double((btnPrice.currentTitle?.getCurrencyNumber())!)
        let orderType = swType.rightSelected ? OrderType.Buy : OrderType.Sell
        
        if editMode {
            editAlarm(alarmData[selectedRowEdit].id, email: LogedInUserName, atPrice: SelectedSymbolLastTradePrice, alarmPrice: price, orderType: orderType.rawValue)
        } else {
            addAlarm(LogedInUserName, atPrice: SelectedSymbolLastTradePrice, alarmPrice: price, orderType: orderType.rawValue)
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
            textField.allowedCharacter = "0987654321"
        })
        
        priceAlert.addAction(UIAlertAction(title: Strings.Ok.localized(), style: .Default, handler: {
            (action) -> Void in
            let textField = self.priceAlert.textFields![0] as UITextField
            self.btnPrice.setTitle(textField.text, forState: .Normal)
        }))
        
        self.presentViewController(priceAlert, animated: true, completion: nil)
    }
    
    func deleteTap(sender: AnyObject) {
        selectedRowDelete = sender.tag
        Utils.ShowAlert(self, title: Strings.deleteAlarmTitle.localized(), details: Strings.reallyWantToDeleteAlarm.localized(), btnOkTitle: Strings.Yes.localized(), btnTitles: [Strings.No.localized()], delegate: self)
    }
    
    func editTap(sender: AnyObject) {
        selectedRowEdit = sender.tag
        btnPrice.setTitle(alarmData[selectedRowEdit].alarmPrice.currencyFormat(0), forState: .Normal)
        editMode = true
        btnAdd.setTitle(Strings.Edit.localized(), forState: .Normal)
        
        if alarmData[selectedRowEdit].orderType == OrderType.Buy.rawValue {
            swType.rightSelected = true
        } else {
            swType.rightSelected = false
        }
        
    }
    
    func resetView() {
        btnPrice.setTitle(SelectedSymbolLastTradePrice.currencyFormat(0), forState: .Normal)
        btnAdd.setTitle(Strings.add.localized(), forState: .Normal)
    }
    
    @IBAction func swValueChanged(sender: AnyObject) {
        
    }
    
    //MARK: -AlertView delegates
    
    func FCAlertDoneButtonClicked(alertView: FCAlertView!) {
        
        deleteAlarm(alarmData[selectedRowDelete].id, email: LogedInUserName)
        
    }
}

struct AlarmsData {
    let active: Bool!
    let alarmPrice: Float!
    let atPrice: Float!
    let descriptionField: String!
    let id: Int!
    let orderType: String!
    let priceDirection: String!
    let symbolCode: Int64!
    
}

enum OrderType: String {
    case Sell = "SELL"
    case Buy = "BUY"
}
