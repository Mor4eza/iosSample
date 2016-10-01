//
//  PortfolioListViewController.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/30/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu
import SQLite
import SwiftEventBus
import Alamofire
import Alamofire_Gloss
import KCFloatingActionButton
import FCAlertView
class PortfolioListViewController: BaseViewController ,UITableViewDataSource , UITableViewDelegate , KCFloatingActionButtonDelegate , FCAlertViewDelegate{
    let db = DataBase()
    var currentPortfolio = String()
    var portfolios = [String]()
    var symbols = [String]()
    var smData = [symData]()
    var selectedSymbolCode = String()
    var menuView:BTNavigationDropdownMenu!
    var selectedSymbolPrice = Float()
    var fab = KCFloatingActionButton()
    let addPortfolio = KCFloatingActionButtonItem()
    let editPortfolio = KCFloatingActionButtonItem()
    let searchSymbol = KCFloatingActionButtonItem()
    let addSymbol = KCFloatingActionButtonItem()
    let deletePortfolio = KCFloatingActionButtonItem()
    var searchableSymbols = Bool()
    //    var refreshControll = UIRefreshControl!()
    @IBOutlet weak var tblPortfolio: UITableView!
    let nc = NSNotificationCenter.defaultCenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPortfolio.backgroundView?.backgroundColor = AppBackgroundLight
        self.tblPortfolio.backgroundColor = AppBackgroundLight
        self.view.backgroundColor = AppBackgroundLight
        tblPortfolio.delegate = self
        tblPortfolio.dataSource = self
        getCurrentPortfolio()
        initNavigationTitle()

        initFAB()
        SwiftEventBus.onMainThread(self, name: BestBuyClosed) { result in
            self.loadSymbolsFromDb()

        }

    }

    func showHintView(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey(HINT)  == false && smData.count > 0{

            let imageName = UIConstants.tooltipHand
            let image = UIImage(named: imageName)
            let hintImage = UIImageView(image: image!)
            hintImage.frame = CGRect(x: view.bounds.midX + 50, y: view.bounds.minY + 100, width: 50, height: 50)
            view.addSubview(hintImage)

            UIView.animateWithDuration(2, delay:0, options: .Autoreverse, animations: {

                hintImage.frame = CGRect(x: self.view.bounds.midX - 50, y: self.view.bounds.minY + 100, width: 50, height: 50)

                }, completion: {

                    (value: Bool) in
                    hintImage.removeFromSuperview()
            })

            defaults.setBool(true, forKey: HINT)
        }

    }

    override func viewWillAppear(animated: Bool) {
        nc.addObserver(self, selector: #selector(selectedSymbol), name: symbolSelected, object: nil)
        SwiftEventBus.onMainThread(self, name: PortfolioEdited) { result in
            debugPrint("Edited")
            self.initNavigationTitle()
        }

        loadSymbolsFromDb()

        if portfolios.count == 0 {
            addPortfolio.hidden = false
            editPortfolio.hidden = true
            searchSymbol.hidden = true
            addSymbol.hidden = true
            deletePortfolio.hidden = true

        }else{
            addPortfolio.hidden = false
            editPortfolio.hidden = false
            searchSymbol.hidden = false
            addSymbol.hidden = false
            deletePortfolio.hidden = false
        }
    }

    override func viewWillDisappear(animated: Bool) {
        SwiftEventBus.unregister(self)

    }
    //MARK: - TableView Delegate

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return smData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.portfolioCell, forIndexPath: indexPath) as! portfolioCell

        cell.lblSymbolValue.text = smData[indexPath.row].symbolNameFa
        cell.lblLastPriceValue.text = smData[indexPath.row].closePrice.currencyFormat(2)
        cell.lblBuyQuotValue.text = smData[indexPath.row].benchmarkBuy.currencyFormat(2)
        cell.lblSellQuotValue.text = smData[indexPath.row].benchmarkSales.currencyFormat(2)
        if smData[indexPath.row].todayProfit > 0 {
            cell.lblTodayValue.textColor = UIColor.greenColor()
        }else {
            cell.lblTodayValue.textColor = UIColor.redColor()
        }

        if smData[indexPath.row].totalProfit > 0 {
            cell.lblOverValue.textColor = UIColor.greenColor()
        }else {
            cell.lblOverValue.textColor = UIColor.redColor()
        }

        cell.lblTodayValue.text = smData[indexPath.row].todayProfit.currencyFormat(2)
        cell.lblOverValue.text = smData[indexPath.row].totalProfit.currencyFormat(2)
        cell.lblEndValue.text = smData[indexPath.row].lastTradePrice.currencyFormat(2)
        cell.lblEndChanges.text = smData[indexPath.row].closePriceChange.currencyFormat(2)
        if smData[indexPath.row].status == "IS" {
            cell.lblStatusValue.text = Strings.stopped.localized()
            cell.viewStatus.backgroundColor = UIColor.redColor()
        }else {
            cell.lblStatusValue.text = Strings.allowed.localized()
            cell.viewStatus.backgroundColor = UIColor(netHex: 0x024b30)
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        SelectedSymbolCode = smData[indexPath.row].symbolCode
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?  {
        // 1
        let buyInformation = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: Strings.BuyInformation.localized() , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            SelectedSymbolName = self.smData[indexPath.row].symbolNameFa
            SelectedSymbolCode = self.smData[indexPath.row].symbolCode
            self.selectedSymbolPrice = self.smData[indexPath.row].lastTradePrice
            self.performSegueWithIdentifier(UIConstants.buyInfoSegue, sender: nil)

        })

        return [buyInformation]
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }

    func selectedSymbol(notification: NSNotification) {
        nc.removeObserver(self)
        selectedSymbolCode = notification.userInfo!["selectedSymbol"] as! String
        debugPrint("code: \(selectedSymbolCode)")

        db.addSymbolToPortfolio(selectedSymbolCode, pCode: db.getportfolioCodeByName(currentPortfolio))

        self.loadSymbolsFromDb()

    }

    func loadSymbolsFromDb(){
        symbols = db.getSymbolbyPortfolio(db.getportfolioCodeByName(currentPortfolio))
        if symbols.count > 0 {
            getSymbolListData(symbols)
        }else {
            smData.removeAll()
            tblPortfolio.reloadData()
        }
    }

    //MARK:- Navigation Title

    func getCurrentPortfolio(){

        portfolios = db.getPortfolioList(1)
        if portfolios.count > 0 {
            currentPortfolio = portfolios[0]
        }else {
            currentPortfolio = ""
        }
    }

    func initNavigationTitle(){

        portfolios = db.getPortfolioList(1)
        if portfolios.count == 0 {
            menuView = BTNavigationDropdownMenu(title: Strings.Portfolio.localized(), items: portfolios)
            currentPortfolio = ""
        }else {
            menuView = BTNavigationDropdownMenu(title:currentPortfolio, items: portfolios)
        }

        menuView.animationDuration = 0.5
        menuView.cellTextLabelAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = menuView

        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in

            self.currentPortfolio = self.portfolios[indexPath]
            debugPrint("currentPortfolio\(self.db.getportfolioCodeByName(self.currentPortfolio))")
            self.loadSymbolsFromDb()
        }

    }
    //MARK:- Floation Button

    func initFAB(){

        self.fab.removeFromSuperview()

        addPortfolio.icon = UIImage(named: UIConstants.icAddPortfolio)
        addPortfolio.title = Strings.AddPortfolio.localized()

        editPortfolio.icon = UIImage(named: UIConstants.icEditPortfolio)
        editPortfolio.title = Strings.EditPortfolio.localized()

        searchSymbol.icon = UIImage(named: UIConstants.icSearch)
        searchSymbol.title = Strings.SearchSymbol.localized()

        addSymbol.icon = UIImage(named: UIConstants.icAddSymbol)
        addSymbol.title = Strings.AddSymbol.localized()

        deletePortfolio.icon = UIImage(named: UIConstants.icDeletePortfolio)
        deletePortfolio.title = Strings.DeletePortfolio.localized()

        addPortfolio.handler = { item in

            var tField: UITextField!

            func configurationTextField(textField: UITextField!)
            {
                textField.placeholder = Strings.EnterPortfolioName.localized()
                textField.changeDirection()
                tField = textField
            }

            func handleCancel(alertView: UIAlertAction!)
            {

            }

            let alert = UIAlertController(title: Strings.AddPortfolio.localized(), message: "", preferredStyle: .Alert)

            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: Strings.Cancel.localized(), style: .Cancel, handler:handleCancel))
            alert.addAction(UIAlertAction(title: Strings.Submit.localized(), style: .Default, handler:{ (UIAlertAction) in

                if !(tField.text?.isEmpty)! {

                    for i in 0  ..< self.portfolios.count {
                        if(tField.text == self.portfolios[i]){
                        Utils.ShowAlert(self, title:Strings.Attention.localized() , details: "نام پرتفوی تکراری است.",btnOkTitle:Strings.Ok.localized())
                            return
                        }
                    }
                    self.db.addPortfolio(tField.text!)
                    self.portfolios = self.db.getPortfolioList(1)
                    self.currentPortfolio = self.portfolios.last!
                    self.initNavigationTitle()
                    self.menuView.updateItems(self.portfolios)
                    self.performSegueWithIdentifier(UIConstants.searchSeguei, sender: nil)
                }else {

                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }

        editPortfolio.handler =  { item in

            self.performSegueWithIdentifier(UIConstants.editSegue, sender: nil)
        }

        addSymbol.handler = { item in

            self.searchableSymbols = false
            self.performSegueWithIdentifier(UIConstants.searchSeguei, sender: nil)

        }

        searchSymbol.handler =  { item in

            self.searchableSymbols = true
            self.performSegueWithIdentifier(UIConstants.searchSeguei, sender: nil)

        }

        deletePortfolio.handler = { item in

            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.RealyWantToDelete.localized(), btnOkTitle: Strings.Yes.localized(), btnTitles: [Strings.No.localized()],delegate: self)

        }

        fab.fabDelegate = self

        fab.removeItem(item: addPortfolio)
        fab.addItem(item: addPortfolio)
        fab.addItem(item: deletePortfolio)
        fab.addItem(item: editPortfolio)
        fab.addItem(item: searchSymbol)
        fab.addItem(item: addSymbol)
        addPortfolio.hidden = true
        self.view.addSubview(fab)

    }

    //MARK:- Get Symbols Data Service

    func getSymbolListData(symbols:[String]) {

        let url = AppTadbirUrl + URLS["getSymbolListAndDetails"]!

        // JSON Body
        let body = SymbolListAndDetailsRequest(pageNumber: 0, recordPerPage: 0, symbolCode: symbols, supportPaging: false).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (symbols:MainResponse<SymbolListModelResponse>?, error)  in

            if ((symbols?.successful) != nil) {
                self.smData.removeAll()

                for i in 0  ..< symbols!.response.symbolDetailsList.count{

                    self.smData.append(symData(name: symbols!.response.symbolDetailsList[i].symbolNameFa, baseValue: symbols!.response.symbolDetailsList[i].baseValue, benchmarkBuy: symbols!.response.symbolDetailsList[i].benchmarkBuy, benchmarkSales: symbols!.response.symbolDetailsList[i].benchmarkSales, buyValue: symbols!.response.symbolDetailsList[i].buyValue, closePrice: symbols!.response.symbolDetailsList[i].closePrice, closePriceChange: symbols!.response.symbolDetailsList[i].closePriceChange, closePriceYesterday: symbols!.response.symbolDetailsList[i].closePriceYesterday, descriptionField: symbols!.response.symbolDetailsList[i].descriptionField, eps: symbols!.response.symbolDetailsList[i].eps, highPrice: symbols!.response.symbolDetailsList[i].highPrice, lastTradeDate: symbols!.response.symbolDetailsList[i].lastTradeDate, lastTradePrice: symbols!.response.symbolDetailsList[i].lastTradePrice, lastTradePriceChange: symbols!.response.symbolDetailsList[i].lastTradePriceChange, lastTradePriceChangePercent: symbols!.response.symbolDetailsList[i].lastTradePriceChangePercent, lowPrice: symbols!.response.symbolDetailsList[i].lowPrice, marketValue: symbols!.response.symbolDetailsList[i].marketValue, openPrice: symbols!.response.symbolDetailsList[i].openPrice, pe: symbols!.response.symbolDetailsList[i].pe, status: symbols!.response.symbolDetailsList[i].status, symbolCode: symbols!.response.symbolDetailsList[i].symbolCode, symbolCompleteNameFa: symbols!.response.symbolDetailsList[i].symbolCompleteNameFa, symbolNameEn: symbols!.response.symbolDetailsList[i].symbolNameEn, symbolNameFa: symbols!.response.symbolDetailsList[i].symbolNameFa, todayPrice: symbols!.response.symbolDetailsList[i].todayPrice, todayProfit:self.getBuyData(symbols!.response.symbolDetailsList[i].symbolCode,price: symbols!.response.symbolDetailsList[i].lastTradePrice).today, totalProfit:self.getBuyData(symbols!.response.symbolDetailsList[i].symbolCode,price: symbols!.response.symbolDetailsList[i].closePrice).overAll, transactionNumber: symbols!.response.symbolDetailsList[i].transactionNumber, transactionVolume: symbols!.response.symbolDetailsList[i].transactionVolume))
                }

                self.tblPortfolio.reloadData()
                self.showHintView()
            } else {
                debugPrint(error)
            }
            //                self.refreshControll?.endRefreshing()
        }
    }

    func getBuyData(symbolCode:String ,price:Float) -> (today:Double , overAll:Double) {
        var todayProfit = Double()
        var overAllProfit  = Double()
        var psCode = Int()
        debugPrint("price: \(price)")

        psCode = db.getPsCodeBySymbolCode(symbolCode, pCode: db.getportfolioCodeByName(currentPortfolio))
        if db.getPsBuy(psCode).count > 0 {

            debugPrint("count: \(db.getPsBuy(psCode).count)")

            for i in 0..<db.getPsBuy(psCode).count{

                todayProfit += (Double(price) - db.getPsBuy(psCode)[i].psPrice) * db.getPsBuy(psCode)[i].psCount
                overAllProfit += (Double(price) - db.getPsBuy(psCode)[i].psPrice) * db.getPsBuy(psCode)[i].psCount

            }

        }

        return (todayProfit , overAllProfit)
    }

    //MARK:- Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == UIConstants.symbolDetailsSegue {

            let indexPath = tblPortfolio.indexPathForSelectedRow!

            SelectedSymbolName = smData[indexPath.row].symbolNameFa

            let backItem = UIBarButtonItem()
            backItem.title = Strings.Back.localized()
            navigationItem.backBarButtonItem = backItem

            SelectedSymbolCode = smData[indexPath.row].symbolCode

        }

        if segue.identifier == UIConstants.editSegue {

            let nav = segue.destinationViewController as! UINavigationController

            let editController = nav.topViewController as! EditPortfolioViewController

            editController.portfolioName = currentPortfolio
            editController.portfolios = self.portfolios
            for index in 0..<symbols.count {
                editController.symbolData.append(symbolsDataForEdit(sName: smData[index].symbolNameFa, sNameEn: smData[index].symbolNameEn, sCode: smData[index].symbolCode))
            }

        }
        if segue.identifier == UIConstants.buyInfoSegue {

            let buyInfo = segue.destinationViewController as! BuyInfoViewController
            buyInfo.portfolioCode = db.getportfolioCodeByName(currentPortfolio)
            buyInfo.price = self.selectedSymbolPrice

        }
        if segue.identifier == UIConstants.searchSeguei {
            let nav = segue.destinationViewController as! UINavigationController
            let addVC =  nav.topViewController as! SearchSeymbolTableView
            addVC.isSearch = searchableSymbols
            addVC.symbols = symbols
        }
    }

     //MARK:- AlertView Delegates

    func FCAlertDoneButtonClicked(alertView: FCAlertView){

        db.deleteAllSymbolsInPortfolio(self.db.getportfolioCodeByName(self.currentPortfolio))
        db.deletePortfolio(self.db.getportfolioCodeByName(self.currentPortfolio))
        getCurrentPortfolio()
        loadSymbolsFromDb()
        initNavigationTitle()
    }
}

//MARK:- Symbol Data Model
struct symData {

    var name = String()
    var baseValue : Double!
    var benchmarkBuy : Double!
    var benchmarkSales : Double!
    var buyValue : Double!
    var closePrice : Float!
    var closePriceChange : Double!
    var closePriceYesterday : Float!
    var descriptionField : AnyObject!
    var eps : Double!
    var highPrice : Float!
    var lastTradeDate : String!
    var lastTradePrice : Float!
    var lastTradePriceChange : Float!
    var lastTradePriceChangePercent : Double!
    var lowPrice : Float!
    var marketValue : Double!
    var openPrice : Float!
    var pe : Double!
    var status : String!
    var symbolCode : String!
    var symbolCompleteNameFa : String!
    var symbolNameEn : String!
    var symbolNameFa : String!
    var todayPrice : Double!
    var todayProfit : Double!
    var totalProfit : Double!
    var transactionNumber : Float!
    var transactionVolume : Float!

}
