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

class PortfolioListViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, KCFloatingActionButtonDelegate {
    let db = DataBase()
    var currentPortfolioIndex = 0
    var currentPortfolio: Portfolio?
    var portfolios = [Portfolio]()
    var portfolioNames = [String]()
    var symbols = [String]()
    var smData = [symData]()
    var selectedSymbolCode = String()
    var menuView: BTNavigationDropdownMenu!
    var selectedSymbolPrice = Double()
    var fab = KCFloatingActionButton()
    let addPortfolio = KCFloatingActionButtonItem()
    let editPortfolio = KCFloatingActionButtonItem()
    let searchSymbol = KCFloatingActionButtonItem()
    let addSymbol = KCFloatingActionButtonItem()
    let deletePortfolio = KCFloatingActionButtonItem()
    var lastUpdate = NSMutableAttributedString()
    var searchableSymbols = Bool()
    let refreshControl = UIRefreshControl()
    let defaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var tblPortfolio: UITableView!
    let nc = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var lblLastUpdate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPortfolioIndex = defaults.integerForKey("currentPortfolioIndex")
        
        self.tblPortfolio.backgroundView?.backgroundColor = AppBackgroundLight
        self.tblPortfolio.backgroundColor = AppBackgroundLight
        self.view.backgroundColor = AppBackgroundLight
        self.tblPortfolio.registerNib(UINib(nibName: UIConstants.PortfolioHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: UIConstants.PortfolioHeader)
        tblPortfolio.delegate = self
        tblPortfolio.dataSource = self
        getCurrentPortfolio()
        initNavigationTitle()
        refreshControl.tintColor = UIColor.whiteColor()
        self.tblPortfolio.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height)
        refreshControl.addTarget(self, action: #selector(IndexTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tblPortfolio.addSubview(refreshControl)
        
        initFAB()
    }
    
    func refresh(sender: AnyObject) {
        loadSymbolsFromDb()
    }
    
    func showHintView() {
        
        if ((smData.count > 0) && (self.defaults.integerForKey(NumberOfLogins) < 4)) {
            
            let imageName = UIConstants.tooltipHand
            let image = UIImage(named: imageName)
            let hintImage = UIImageView(image: image!)
            hintImage.frame = CGRect(x: view.bounds.midX + 50, y: view.bounds.minY + 100, width: 50, height: 50)
            view.addSubview(hintImage)
            
            UIView.animateWithDuration(2, delay: 0, options: .Autoreverse, animations: {
                
                hintImage.frame = CGRect(x: self.view.bounds.midX - 50, y: self.view.bounds.minY + 100, width: 50, height: 50)
                
                }, completion: {
                    
                    (value: Bool) in
                    hintImage.removeFromSuperview()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        nc.addObserver(self, selector: #selector(selectedSymbol), name: symbolSelected, object: nil)
        SwiftEventBus.onMainThread(self, name: PortfolioEdited) {
            result in
            debugPrint("Edited")
            self.getCurrentPortfolio()
            self.initNavigationTitle()
            self.loadSymbolsFromDb()
        }
        
        loadSymbolsFromDb()
        changeFabState()
    }
    
    override func viewWillDisappear(animated: Bool) {
        SwiftEventBus.unregister(self)
        
    }
    
    func changeFabState() {
        if portfolios.count == 0 {
            addPortfolio.hidden = false
            editPortfolio.hidden = true
            searchSymbol.hidden = true
            addSymbol.hidden = true
            deletePortfolio.hidden = true
            
        } else {
            addPortfolio.hidden = false
            editPortfolio.hidden = false
            searchSymbol.hidden = false
            addSymbol.hidden = false
            deletePortfolio.hidden = false
        }
        if portfolios.count == 0 {
            dispatch_async(dispatch_get_main_queue()) {
                Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.addPortfolioPlease.localized())
            }
        }
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
        
       cell.initCells(smData[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SelectedSymbolCode = smData[indexPath.row].symbolCode
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        // 1
        let buyInformation = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: Strings.BuyInformation.localized(), handler: {
            (action: UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            SwiftEventBus.onMainThread(self, name: BestBuyClosed) {
                result in
                self.loadSymbolsFromDb()
                
            }
            SelectedSymbolName = self.smData[indexPath.row].symbolShortName
            SelectedSymbolCode = self.smData[indexPath.row].symbolCode
            self.selectedSymbolPrice = self.smData[indexPath.row].benchmarkBuy
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
        
        db.addSymbolToPortfolio(selectedSymbolCode, pCode: currentPortfolio!.portfolioCode)
        
        self.loadSymbolsFromDb()
        
    }
    
    func loadSymbolsFromDb() {
        if currentPortfolio != nil {
            symbols = db.getSymbolbyPortfolio(currentPortfolio!.portfolioCode)
        }
        
        if symbols.count > 0 {
            var intSymbols = [Int64]()
            for symbol in symbols {
                intSymbols.append(Int64(symbol)!)
            }
            getSymbolListData(intSymbols)
        } else {
            smData.removeAll()
            tblPortfolio.reloadData()
        }
    }
    
    //MARK:- Navigation Title
    
    func getCurrentPortfolio() {
        
        loadPortfolioListsFromDB()
        if portfolios.count > 0 {
            currentPortfolio = portfolios[currentPortfolioIndex]
        }
        
    }
    
    func loadPortfolioListsFromDB() {
        
        portfolios.removeAll()
        portfolios = db.getPortfolioList(LogedInUserId)
        portfolioNames.removeAll()
        for portfolio in portfolios {
            portfolioNames.append(portfolio.portfolioName)
        }
        
    }
    
    func initNavigationTitle() {
        
        loadPortfolioListsFromDB()
        
        if portfolios.count == 0 {
            menuView = BTNavigationDropdownMenu(title: Strings.Portfolio.localized(), items: portfolioNames)
        }else {
            menuView = BTNavigationDropdownMenu(title: currentPortfolio!.portfolioName, items: portfolioNames)
        }
        
        
        menuView.animationDuration = 0.5
        menuView.cellTextLabelAlignment = NSTextAlignment.Center
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {
            (indexPath: Int) -> () in
            if self.sideMenuController()?.sideMenu?.isMenuOpen == true {
                self.sideMenuController()?.sideMenu?.hideSideMenu()
            }
            self.currentPortfolio = self.portfolios[indexPath]
            self.currentPortfolioIndex = indexPath
            debugPrint("currentPortfolio\(self.currentPortfolio!.portfolioCode)")
//            self.defaults.setValue(self.currentPortfolio?.portfolioName, forKey: "currentPortfolioName" )
            self.defaults.setInteger(self.currentPortfolioIndex, forKey: "currentPortfolioIndex")
            self.loadSymbolsFromDb()
        }
        
    }
    
    //MARK:- Floation Button
    
    func initFAB() {
        
        self.fab.removeFromSuperview()
        fab.plusColor = UIColor.whiteColor()
        fab.friendlyTap = true
        fab.overlayColor = AppMainColor.colorWithAlphaComponent(0.8)
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
        
        addPortfolio.handler = {
            item in
            
            var tField: UITextField!
            
            func configurationTextField(textField: UITextField!) {
                textField.placeholder = Strings.EnterPortfolioName.localized()
                textField.changeDirection()
                tField = textField
            }
            
            func handleCancel(alertView: UIAlertAction!) {
                
            }
            
            let alert = UIAlertController(title: Strings.AddPortfolio.localized(), message: "", preferredStyle: .Alert)
            
            alert.addTextFieldWithConfigurationHandler(configurationTextField)
            alert.addAction(UIAlertAction(title: Strings.Cancel.localized(), style: .Cancel, handler: handleCancel))
            alert.addAction(UIAlertAction(title: Strings.Submit.localized(), style: .Default, handler: {
                (UIAlertAction) in
                
                if !(tField.text?.isEmpty)! {
                    
                    if tField.text?.characters.count > 30 {
                        
                        Utils.ShowAlert(self, title: Strings.Attention.localized(), details: "نام پرتفوی نباید بیش از ۳۰ کاراکتر باشد.", btnOkTitle: Strings.Ok.localized())
                        
                        return
                    }
                    
                    for i in 0 ..< self.portfolios.count {
                        if (tField.text == self.portfolios[i].portfolioName) {
                            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: "نام پرتفوی تکراری است.", btnOkTitle: Strings.Ok.localized())
                            return
                        }
                    }
                    self.db.addPortfolio(tField.text!.trim(), userId: LogedInUserId)
                    self.portfolios = self.db.getPortfolioList(LogedInUserId)
                    self.currentPortfolio = self.portfolios.last!
                    self.initNavigationTitle()
                    self.menuView.updateItems(self.portfolioNames)
                    self.performSegueWithIdentifier(UIConstants.addMultipleSegue, sender: nil)
                    
                } else {
                    Utils.ShowAlert(self, title: Strings.Attention.localized(), details: "نام پرتفوی را وارد کنید.", btnOkTitle: Strings.Ok.localized())
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        editPortfolio.handler = {
            item in
            
            self.performSegueWithIdentifier(UIConstants.editSegue, sender: nil)
        }
        
        addSymbol.handler = {
            item in
            
            self.searchableSymbols = false
            self.performSegueWithIdentifier(UIConstants.addSegue, sender: nil)
            
        }
        
        searchSymbol.handler = {
            item in
            
            self.searchableSymbols = true
            self.performSegueWithIdentifier(UIConstants.searchSeguei, sender: nil)
            
        }
        
        deletePortfolio.handler = {
            item in
            
            Utils.ShowAlert(self, title: Strings.Attention.localized(), details: Strings.RealyWantToDelete.localized(), btnOkTitle: Strings.Yes.localized(), btnTitles: [Strings.No.localized()], delegate: self)
            
        }
        
        fab.fabDelegate = self
        
        fab.removeItem(item: addPortfolio)
        
        fab.addItem(item: addPortfolio)
        fab.addItem(item: addSymbol)
        fab.addItem(item: searchSymbol)
        fab.addItem(item: editPortfolio)
        fab.addItem(item: deletePortfolio)
        
        addPortfolio.hidden = true
        self.view.addSubview(fab)
        
    }
    
    //MARK:- Get Symbols Data Service
    
    func getSymbolListData(symbols: [Int64]) {
        
        refreshControl.beginRefreshing()
        
        let url = AppTadbirUrl + URLS["getSymbolListAndDetails"]!
        
        // JSON Body
        let body = SymbolListAndDetailsRequest(pageNumber: 0, recordPerPage: 0, symbolCode: symbols, supportPaging: false, language: getAppLanguage()).getDic()
        
        // Fetch Request
        Request.postData(url, body: body) {
            (symbols: MainResponse<SymbolListModelResponse>?, error) in
            
            if ((symbols?.successful) != nil) {
                self.smData.removeAll()
                self.lblLastUpdate.attributedText = (symbols?.convertTime())!
                
                for i in 0 ..< symbols!.response.symbolDetailsList.count {
                    
                    self.smData.append(symData(benchmarkBuy: symbols!.response.symbolDetailsList[i].benchmarkBuy,
                        benchmarkSales: symbols!.response.symbolDetailsList[i].benchmarkSales,
                        closePrice: symbols!.response.symbolDetailsList[i].closePrice,
                        closePriceChange: symbols!.response.symbolDetailsList[i].closePriceChange,
                        lastTradePrice: symbols!.response.symbolDetailsList[i].lastTradePrice,
                        lastTradePriceChange: symbols!.response.symbolDetailsList[i].lastTradePriceChange,
                        lastTradePriceChangePercent: symbols!.response.symbolDetailsList[i].lastTradePriceChangePercent,
                        status: symbols!.response.symbolDetailsList[i].status,
                        symbolCode: symbols!.response.symbolDetailsList[i].symbolCode,
                        symbolCompleteName: symbols!.response.symbolDetailsList[i].symbolCompleteName,
                        symbolShortName: symbols!.response.symbolDetailsList[i].symbolShortName,
                        todayProfit: self.getBuyData(String(symbols!.response.symbolDetailsList[i].symbolCode), price: Float(symbols!.response.symbolDetailsList[i].lastTradePrice)).today,
                        totalProfit: self.getBuyData(String(symbols!.response.symbolDetailsList[i].symbolCode), price: Float(symbols!.response.symbolDetailsList[i].closePrice)).overAll,
                        buyValue: symbols!.response.symbolDetailsList[i].buyValue))
                    
                }
                
                self.tblPortfolio.reloadData()
                self.refreshControl.endRefreshing()
                self.showHintView()
            } else {
                self.refreshControl.endRefreshing()
                debugPrint("Error \(error)")
            }
            //                self.refreshControll?.endRefreshing()
        }
    }
    
    func getBuyData(symbolCode: String, price: Float) -> (today: Double, overAll: Double) {
        var todayProfit = Double()
        var overAllProfit = Double()
        var psCode = Int()
        debugPrint("price: \(price)")
        
        psCode = db.getPsCodeBySymbolCode(symbolCode, pCode: currentPortfolio!.portfolioCode)
        
        
        
        for i in 0 ..< db.getPsBuy(psCode).count {
            
            todayProfit += (Double(price) - db.getPsBuy(psCode)[i].psPrice) * db.getPsBuy(psCode)[i].psCount
            overAllProfit += (Double(price) - db.getPsBuy(psCode)[i].psPrice) * db.getPsBuy(psCode)[i].psCount
            
        }
        return (todayProfit, overAllProfit)
    }
    
    
    
    //MARK:- Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == UIConstants.symbolDetailsSegue {
            
            let indexPath = tblPortfolio.indexPathForSelectedRow!
            
            SelectedSymbolName = smData[indexPath.row].symbolShortName
            
            let backItem = UIBarButtonItem()
            backItem.title = Strings.Back.localized()
            navigationItem.backBarButtonItem = backItem
            
            SelectedSymbolCode = smData[indexPath.row].symbolCode
            
        }
        
        if segue.identifier == UIConstants.editSegue {
            
            let nav = segue.destinationViewController as! UINavigationController
            
            let editController = nav.topViewController as! EditPortfolioViewController
            
            editController.portfolioName = currentPortfolio!.portfolioName
            editController.portfolios = portfolioNames
            if symbols.count != 0 {
                for index in 0 ..< symbols.count {
                    editController.symbolData.append(symbolsDataForEdit(sName: smData[index].symbolShortName, sNameEn: smData[index].symbolShortName, sCode: String(smData[index].symbolCode)))
                }
            }
            
        }
        if segue.identifier == UIConstants.buyInfoSegue {
            
            let buyInfo = segue.destinationViewController as! BuyInfoViewController
            buyInfo.portfolioCode = currentPortfolio!.portfolioCode
            buyInfo.price = Float(self.selectedSymbolPrice)
            
        }
        if segue.identifier == UIConstants.searchSeguei {
            let nav = segue.destinationViewController as! UINavigationController
            let addVC = nav.topViewController as! SearchSeymbolTableView
            addVC.isSearch = searchableSymbols

            addVC.singleSelection = true
            addVC.pCode = currentPortfolio!.portfolioCode
            addVC.symbols = symbols
        }
        
        if segue.identifier == UIConstants.addMultipleSegue {
            let nav = segue.destinationViewController as! UINavigationController
            let addVC = nav.topViewController as! SearchSeymbolTableView
            addVC.isSearch = searchableSymbols

            addVC.singleSelection = false
            addVC.pCode = currentPortfolio!.portfolioCode
            addVC.symbols = symbols
        }
        
        if segue.identifier == UIConstants.addSegue {
            let nav = segue.destinationViewController as! UINavigationController
            let addVC = nav.topViewController as! SearchSeymbolTableView
            addVC.isSearch = searchableSymbols

            addVC.singleSelection = true
            addVC.pCode = currentPortfolio!.portfolioCode
            addVC.symbols = symbols
        }
        
    }
    
    //MARK:- AlertView Delegates
    
    func FCAlertDoneButtonClicked(alertView: FCAlertView) {
        
        db.deleteAllSymbolsInPortfolio(currentPortfolio!.portfolioCode)
        db.deletePortfolio(currentPortfolio!.portfolioCode)
        
        if (currentPortfolioIndex > 0) {
            currentPortfolioIndex = currentPortfolioIndex - 1
            self.defaults.setInteger(self.currentPortfolioIndex, forKey: "currentPortfolioIndex")
        }
        
        getCurrentPortfolio()
        loadSymbolsFromDb()
        initNavigationTitle()
        changeFabState()
    }
    
    override func updateServiceData() {
        loadSymbolsFromDb()
    }
    
    override func sideMenuDidOpen() {
        menuView.hide()
    }
}

//MARK:- Symbol Data Model

struct symData {
    
    var benchmarkBuy: Double!
    var benchmarkSales: Double!
    var closePrice: Double!
    var closePriceChange: Double!
    var lastTradePrice: Double!
    var lastTradePriceChange: Double!
    var lastTradePriceChangePercent: Double!
    var status: String!
    var symbolCode: Int64!
    var symbolCompleteName: String!
    var symbolShortName: String!
    var todayProfit: Double!
    var totalProfit: Double!
    var buyValue: Double!
    
}

struct Portfolio {
    var portfolioCode: Int!
    var portfolioName: String!
}
