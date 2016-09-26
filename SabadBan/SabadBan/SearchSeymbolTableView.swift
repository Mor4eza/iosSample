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

class SearchSeymbolTableView: BaseTableViewController ,UISearchResultsUpdating , UISearchBarDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var symbolsData = [symbolData]()
    var filteredSymbol = [symbolData]()
    var selectedSCode = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        getSymbolList()
        self.title = "SearchSymbol".localized()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "SearchSymbol".localized()
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        
        let btnDone = UIButton()
        btnDone.setTitle("❌", forState: .Normal)
        btnDone.frame = CGRectMake(0, 0, 30, 30)
        btnDone.addTarget(self, action: #selector(doneClicked), forControlEvents: .TouchUpInside)
        let rightBarButton = UIBarButtonItem(customView: btnDone)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    func doneClicked()  {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source
    
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SymbolsCell", forIndexPath: indexPath) as! SymbolNamesCell
        
        
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
        
        let nc = NSNotificationCenter.defaultCenter()
        
        var selected = String()
        if shouldShowSearchResults {
            selected = filteredSymbol[indexPath.row].code
        }else{
            selected = symbolsData[indexPath.row].code
        }
        
        let sendSelected = ["selectedSymbol":selected]
        nc.postNotificationName("SYMBOL_SELECTED", object: nil , userInfo: sendSelected)
        dismissViewControllerAnimated(true, completion: nil)
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
        
        let url = AppTadbirUrl + URLS["getSymbolListAndDetails"]!
        
        // JSON Body
        let body = [
            "pageNumber": 0,
            "recordPerPage": 0,
            "symbolCode": [],
            "supportPaging": false
        ]
        
        // Fetch Request
        Request.postData(url, body: body) { (symbols:MainResponse<SymbolListModelResponse>?, error)  in
            
            if ((symbols?.successful) != nil) {
                for i in 0  ..< symbols!.response.symbolDetailsList.count{
                    if getAppLanguage() == "fa" {
                        self.symbolsData.append(symbolData(name: symbols!.response.symbolDetailsList[i].symbolNameFa, fullName: symbols!.response.symbolDetailsList[i].symbolCompleteNameFa, code: symbols!.response.symbolDetailsList[i].symbolCode))
                        
                    }else if getAppLanguage() == "en" {
                        self.symbolsData.append(symbolData(name: symbols!.response.symbolDetailsList[i].symbolNameEn, fullName: symbols!.response.symbolDetailsList[i].symbolCompleteNameFa, code: symbols!.response.symbolDetailsList[i].symbolCode))
                    }
                    self.tableView.reloadData()
                }
            } else {
                debugPrint(error)
            }
            self.refreshControl?.endRefreshing()
        }
    }
}


struct symbolData {
    
    var name = String()
    var fullName = String()
    var code = String()
}


class smlCode: NSObject {
    var code: String;
    
    init(code: String) {
        self.code = code;
    }
    
}

