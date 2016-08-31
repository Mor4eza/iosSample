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
class SearchSeymbolTableView: BaseTableViewController {

    
    var symbolName = [String]()
    var symbolCode = [String]()
    var symbolFullName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        getSymbolList()
        
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return symbolName.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("symbolsCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = symbolName[indexPath.row]
        
        cell.detailTextLabel?.text = symbolFullName[indexPath.row]
        
        return cell
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
                        self.symbolName.append(symbols.response.symbolDetailsList[i].symbolNameFa)
                        self.symbolCode.append(symbols.response.symbolDetailsList[i].symbolCode)
                        self.symbolFullName.append(symbols.response.symbolDetailsList[i].symbolCompleteNameFa)
                    
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

