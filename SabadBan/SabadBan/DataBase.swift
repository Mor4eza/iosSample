//
//  DataBase.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/30/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import SQLite
class DataBase{
    
    var db:Connection!
    //portfolio Table
    var tblPortfolio:Table!
    let portfolioName = Expression<String?>("portfolioName")
    let portfolioCode = Expression<Int>("portfolioCode")
    let portfolioOwnerId = Expression<Int>("portfolioOwnerUserId")
    
    init(){
        OpenDataBase()
    }
    
    
    func OpenDataBase() {
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)
        let docsDir = dirPaths[0]
        let databasePath = (docsDir as NSString).stringByAppendingPathComponent("sabadbanDb.sqlite")
        debugPrint("\(databasePath)")
        
        db = try! Connection(databasePath)
        
        
        //portfolio Table
        
        tblPortfolio = Table("tbPortfolioSymbol")
        try! db.run(tblPortfolio.create(ifNotExists : true) { t in
            t.column(portfolioCode, primaryKey: true)
            t.column(portfolioName)
            t.column(portfolioOwnerId)
            })
        
        

        
    }
    
    func addPortfolio(pName:String){
        let insert = tblPortfolio.insert(portfolioName <- pName, portfolioOwnerId <- 1)
        try! db.run(insert)
    }
    
    func getPortfolioList(userId:Int)-> [String]{
        
        var pNames = [String]()
        for portfolio in try! db.prepare(tblPortfolio) {
            print("id: \(portfolio[portfolioCode]), name: \(portfolio[portfolioName])")
            pNames.append(portfolio[portfolioName]!)
        }
        return pNames
    }
    
    func getportfolioCodeByName(pName:String)->Int {
        
        var name = Int()
      let  currentQuery = tblPortfolio.select(portfolioCode)
            .filter(portfolioName == pName)
        
        for pn in try!  db.prepare(currentQuery){
            name = pn[portfolioCode]
        }
        
//        let name = try! db.prepare("SELECT portfolioCode FROM tbPortfolioSymbol WHERE portfolioName = '\(pName)' ")
//        name.run(name)
        return name
        
    }
    
    func deletePortfolio(id:Int) {
        
        let portfoi = tblPortfolio.filter(portfolioCode == id)
        try! db.run(portfoi.delete())
    }
}
