//
//  AlarmFilterViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit

class AlarmFilterViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var swType : Switch!
    @IBOutlet var lblTitle :UILabel!
    @IBOutlet var lblType :UILabel!
    @IBOutlet var lblPrice :UILabel!
    @IBOutlet var btnPrice :UIButton!
    @IBOutlet var btnAdd :UIButton!
    @IBOutlet var tblHistory :UITableView!
    
    var alarmData = [AlarmsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        getAlarms("admin@admin.com", symbolCode: 0)
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        
        
        tblHistory.backgroundColor = AppMainColor
        tblHistory.dataSource = self
        tblHistory.delegate = self
        tblHistory.registerNib(UINib(nibName: UIConstants.alarmDataCell, bundle: nil), forCellReuseIdentifier: UIConstants.alarmDataCell)
        tblHistory.registerNib(UINib(nibName: UIConstants.alarmFilterHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.alarmFilterHeader)
        
        lblType.text = Strings.kind.localized()
        lblPrice.text = Strings.Price.localized()
        btnPrice.setTitle("0", forState: .Normal)
        btnAdd.setTitle(Strings.add.localized(), forState: .Normal)
        lblType.setDefaultFont()
        btnPrice.setDefaultFont()
        lblPrice.setDefaultFont()
        btnAdd.setDefaultFont()
        if swType.rightSelected {
            
        }
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
        }else {
            cell.lblType.textColor = UIColor.redColor()
            cell.lblType.text = Strings.sell.localized()
        }
        let active:Bool = alarmData[indexPath.row].active
        if active {
            cell.btnEdit.hidden = false
            cell.lblSymbol.text = Strings.notSended.localized()
        }else{
            cell.btnEdit.hidden = true
            cell.lblSymbol.text = Strings.sended.localized()
        }
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
    
    func getAlarms(email:String ,symbolCode:Int){
        
        let url = AppTadbirUrl + URLS["getAlarmFilters"]!
        
        // JSON Body
//        let body = FindAlarmsRequest(email: email, symbolCode: symbolCode).getDic()
        let body = [
            "email": "admin@admin.com"
        ]
        // Fetch Request
        Request.postData(url, body: body) { (alarms:MainResponse<AlarmResponse>?, error) in
            if ((alarms?.successful) != nil) {
                if  alarms!.response.alarmFilterList.count > 0 {
                    for i in 0 ..< alarms!.response.alarmFilterList.count {
                        self.alarmData.append(AlarmsData(active: alarms?.response.alarmFilterList[i].active,
                            alarmPrice: alarms?.response.alarmFilterList[i].alarmPrice,
                            atPrice: alarms?.response.alarmFilterList[i].atPrice,
                            descriptionField: alarms?.response.alarmFilterList[i].descriptionField,
                            id: alarms?.response.alarmFilterList[i].id,
                            orderType: alarms?.response.alarmFilterList[i].orderType,
                            priceDirection: alarms?.response.alarmFilterList[i].priceDirection,
                            symbolCode: alarms?.response.alarmFilterList[i].symbolCode))
                    }
                    self.tblHistory.reloadData()
                }

            } else {
                debugPrint(error)
            }
        }
        
    }
    
    
    
    @IBAction func btnCloseTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func btnAddTap(sender: AnyObject) {
        
    }
    
    @IBAction func btnPriceTap(sender: AnyObject) {
    }
    @IBAction func swValueChanged(sender: AnyObject) {
        
    }
}

struct AlarmsData {
    let active : Bool!
    let alarmPrice : Float!
    let atPrice : Float!
    let descriptionField : String!
    let id : Int!
    let orderType : String!
    let priceDirection : String!
    let symbolCode : Int!
    
}

enum OrderType :String{
    case Sell = "SELL"
    case Buy = "BUY"
}
