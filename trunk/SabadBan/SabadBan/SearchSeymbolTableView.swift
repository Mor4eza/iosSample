//
//  SearchSeymbolTableView.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/31/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
import SwiftEventBus
import GSMessages
class SearchSeymbolTableView: BaseTableViewController ,UISearchResultsUpdating , UISearchBarDelegate{

    let searchController = UISearchController(searchResultsController: nil)
    let db = DataBase()
    var shouldShowSearchResults = false
    var symbolsData = [symbolData]()
    var filteredSymbol = [symbolData]()
    var selectedSCode = String()
    var isSearch = Bool()
    var symbols = [String]()
    var isFirstTime = Bool()
    var selectedSCodeArray = [String]()
    var pCode = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        if isSearch {
            self.title = Strings.SearchSymbol.localized()
        }else {
            self.title = Strings.AddSymbol.localized()
        }
        self.tableView.allowsMultipleSelection = true
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = Strings.SearchSymbol.localized()
        searchController.searchBar.delegate = self
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        // Include the search bar within the navigation bar.
        self.navigationItem.titleView = self.searchController.searchBar
        self.definesPresentationContext = true

        //Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = UIColor.whiteColor()
        self.tableView.contentOffset = CGPointMake(0, -self.refreshControl!.frame.size.height)
        refreshControl!.addTarget(self, action: #selector(IndexTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)

        let btnDone = UIButton()
        btnDone.setTitle("❌", forState: .Normal)
        btnDone.frame = CGRectMake(0, 0, 30, 30)
        btnDone.addTarget(self, action: #selector(doneClicked), forControlEvents: .TouchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnDone)
        self.navigationItem.rightBarButtonItem = rightBarButton

        getSymbolList()
    }

    func refresh(sender:AnyObject) {
        getSymbolList()
    }

    func doneClicked()  {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if shouldShowSearchResults {
            return filteredSymbol.count
        }
        else {
            return symbolsData.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UIConstants.SymbolsCell, forIndexPath: indexPath) as! SymbolNamesCell

        if shouldShowSearchResults {
            cell.lblName?.text = filteredSymbol[indexPath.row].name
            cell.lblFullName?.text = filteredSymbol[indexPath.row].fullName
        }else{
            cell.lblName?.text = symbolsData[indexPath.row].name
            cell.lblFullName?.text = symbolsData[indexPath.row].fullName
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if isSearch {

            if shouldShowSearchResults {

                SelectedSymbolCode = filteredSymbol[indexPath.row].code
                SelectedSymbolName = filteredSymbol[indexPath.row].name

            }else{

                SelectedSymbolCode = symbolsData[indexPath.row].code
                SelectedSymbolName = symbolsData[indexPath.row].name

            }

            let backItem = UIBarButtonItem()
            backItem.title = Strings.Back.localized()
            navigationItem.backBarButtonItem = backItem

            return
        }

            var selected = String()

            if shouldShowSearchResults {
                selected = String(filteredSymbol[indexPath.row].code)

            }else{
                selected = String(symbolsData[indexPath.row].code)
            }
            symbols = db.getSymbolbyPortfolio(pCode)
            for i in 0 ..< symbols.count {
                if selected == symbols[i] {

                    Utils.ShowAlert(self, title:Strings.Attention.localized() , details: Strings.symbolExists.localized(),btnOkTitle:Strings.Ok.localized())
                    return
                }
            }
            db.addSymbolToPortfolio(selected, pCode: pCode)
        self.showMessage(Strings.addedSuccessfuliToPortfolio.localized(), type: .Success,options: [
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

        if !isFirstTime {
            dismissViewControllerAnimated(true, completion: nil)
        }


    }
    //MARK : - Search Controller

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            shouldShowSearchResults = false
            self.tableView.reloadData()

        }else{
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }

    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        shouldShowSearchResults = false
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            self.tableView.reloadData()
        }

        searchController.searchBar.resignFirstResponder()
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text

        // Filter the data array and get only those countries that match the search text.

        filteredSymbol = symbolsData.filter{ symbol in

            return (symbol.name.lowercaseString.containsString(searchString!.lowercaseString) ||
                symbol.fullName.lowercaseString.containsString(searchString!.lowercaseString))
        }
        // Reload the tableview.
        self.tableView.reloadData()
    }

    //MARK: - Get Symbol List Service

    func getSymbolList() {

        refreshControl?.beginRefreshing()
        let url = AppTadbirUrl + URLS["getSymbolNameList"]!

        // JSON Body
        let body = SymbolNamesRequest(pageNumber: 0, recordPerPage: 0, symbolCode: [], supportPaging: false,language: getAppLanguage()).getDic()

        // Fetch Request
        Request.postData(url, body: body) { (symbols:MainResponse<SymbolNameResponse>?, error)  in

            if ((symbols?.successful) != nil) {
                for i in 0  ..< symbols!.response.symbolNameList.count{
                    self.symbolsData.append(symbolData(name: symbols!.response.symbolNameList[i].symbolShortName,
                        fullName: symbols!.response.symbolNameList[i].symbolCompleteName, code: symbols!.response.symbolNameList[i].symbolCode))

                    self.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            } else {
                debugPrint(error)
            }
            self.refreshControl?.endRefreshing()
        }
    }

    //MARK:- Seguei
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == UIConstants.symDetailsSegue {
            
            if (!isSearch) {
                
                return false
            }else {
                return true
            }
        }
        
        // by default, transition
        return true
    }
}

struct symbolData {
    
    var name = String()
    var fullName = String()
    var code = Int64()
}

class smlCode: NSObject {
    var code: Int64;
    
    init(code: Int64) {
        self.code = code;
    }
    
}
