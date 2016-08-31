//
//  SearchSeymbolTableView.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/31/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire
import Alamofire_Gloss
class SearchSeymbolTableView: BaseTableViewController ,UISearchResultsUpdating , UISearchBarDelegate{
    
    let searchController = UISearchController(searchResultsController: nil)
    var shouldShowSearchResults = false
    var symbolsData = [symbolData]()
    var filteredSymbol = [symbolData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        getSymbolList()
        
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "جستجو"
        searchController.searchBar.delegate = self
        self.tableView.tableHeaderView = searchController.searchBar
        
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SymbolsCell", forIndexPath: indexPath)
        
        if shouldShowSearchResults {
            cell.textLabel?.text = filteredSymbol[indexPath.row].name
            cell.detailTextLabel?.text = filteredSymbol[indexPath.row].fullName
        }else{
            cell.textLabel?.text = symbolsData[indexPath.row].name
            cell.detailTextLabel?.text = symbolsData[indexPath.row].fullName
        }
        
        return cell
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
        let headers = [
            "Content-Type":"application/json",
            ]
        
        // JSON Body
        let body = [
            "pageNumber": 0,
            "recordPerPage": 0,
            "symbolCode": [],
            "supportPaging": false
        ]
        
        // Fetch Request
        Alamofire.request(.POST, url, headers: headers, parameters: body, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObject(symbolListModel.self) { response in
                
                switch response.result {
                case .Success(let symbols):
                    for i in 0  ..< symbols.response.symbolDetailsList.count{
                        self.symbolsData.append(symbolData(name: symbols.response.symbolDetailsList[i].symbolNameFa, fullName: symbols.response.symbolDetailsList[i].symbolCompleteNameFa, code: symbols.response.symbolDetailsList[i].symbolCode))
                        
                        self.tableView.reloadData()
                    }
                    break
                case .Failure(let error):
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



