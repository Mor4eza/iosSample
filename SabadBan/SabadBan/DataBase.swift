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
  
    var tblPortfolio:Table!
    var tblSymbolPortfolio:Table!
    var tblPsBuy:Table!
      //portfolio Table
    let portfolioName = Expression<String?>("portfolioName")
    let portfolioCode = Expression<Int>("portfolioCode")
    let portfolioOwnerId = Expression<Int>("portfolioOwnerUserId")
      //symbol Protfolio
    let psCode = Expression<Int>("psCode")
    let symbolPCode = Expression<Int>("portfolioCode")
    let symbolCode = Expression<String>("symbolCode")
      //psBuy Table
    
    let PS_BUY_ID = Expression<Int>("buyId")
    let PS_BUY_PS_CODE = Expression<Int>("buyPSCode")
    let PS_BUY_PRICE = Expression<Double>("buyPrice")
    let PS_BUY_QUANTITY = Expression<Double>("buyQuantity")
    let PS_BUY_DATE = Expression<String>("buyDate")
    
    
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
        
        tblPortfolio = Table("tbPortfolio")
        try! db.run(tblPortfolio.create(ifNotExists : true) { t in
            t.column(portfolioCode, primaryKey: true)
            t.column(portfolioName)
            t.column(portfolioOwnerId)
            })
        
        //Symbol Table
        
        tblSymbolPortfolio = Table("tbPortfolioSymbol")
        try! db.run(tblSymbolPortfolio.create(ifNotExists : true) { t in
            t.column(psCode, primaryKey: true)
            t.column(symbolPCode)
            t.column(symbolCode)
            })

         //psBuy Table
        
        
        tblPsBuy = Table("tbPsBuy")
        try! db.run(tblPsBuy.create(ifNotExists : true) { t in
            t.column(PS_BUY_ID, primaryKey: true)
            t.column(PS_BUY_PS_CODE)
            t.column(PS_BUY_PRICE)
            t.column(PS_BUY_QUANTITY)
            t.column(PS_BUY_DATE)
            })

    }
    
    
    //MARK: - Symbol
    func addSymbolToPortfolio(sCode:String ,pCode:Int) {
        
        let insert = tblSymbolPortfolio.insert(symbolCode <- sCode , symbolPCode <- pCode)
        try! db.run(insert)
    }
    
    func getSymbolbyPortfolio(pCode:Int) -> [String] {
       
        var symbols = [String]()
        
        
        for symbol in try! db.prepare(tblSymbolPortfolio.filter(symbolPCode == pCode)) {
           
            print("id: \(symbol[psCode]), pCode: \(symbol[symbolPCode]), \(symbol[symbolCode])")
            symbols.append(symbol[symbolCode])
        }
        return symbols
    }
    
    func deleteSymbolFromPortfoi(sCode:String , pCode:Int) {
        
        let symbol = tblSymbolPortfolio.filter(symbolPCode == pCode && symbolCode == sCode)
        try! db.run(symbol.delete())
    }
    
    
    //MARK: - Portfolio
    func addPortfolio(pName:String){
        let insert = tblPortfolio.insert(portfolioName <- pName, portfolioOwnerId <- 1)
        try! db.run(insert)
    }
    
    func getPortfolioList(userId:Int)-> [String]{
        var pNames = [String]()
        for portfolio in try! db.prepare(tblPortfolio) {
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

        return name
        
    }
    
    func getPsCodeBySymbolCode(sCode:String , pCode:Int)-> Int{
        
        
        var pscode = Int()
        let  currentQuery = tblSymbolPortfolio.select(psCode)
            .filter(symbolPCode == pCode && symbolCode == sCode)
        
        for pn in try!  db.prepare(currentQuery){
            pscode = pn[psCode]
        }
        
        return pscode

        
    }
    
    func updatePortfolioName(newName:String , pCode:Int) {
        
        let portfolio = tblPortfolio.filter(portfolioCode == pCode)
        try! db.run(portfolio.update(portfolioName <- newName))
    }
    
    func deletePortfolio(id:Int) {
        
        let portfoi = tblPortfolio.filter(portfolioCode == id)
        try! db.run(portfoi.delete())
    }
    
    
     //MARK:- psBuy
    func addPsBuy(psCode:Int , price:Double , count:Double , date:String){
        
        let insert = tblPsBuy.insert(PS_BUY_PS_CODE <- psCode , PS_BUY_PRICE <- price ,  PS_BUY_QUANTITY <- count ,  PS_BUY_DATE <- date)
        try! db.run(insert)
    }
    
    func getPsBuy(psCode:Int) -> [psBuyModel]{
        
        var psBuys = [psBuyModel]()
        psBuys.removeAll()
        for buys in try! db.prepare(tblPsBuy.filter(PS_BUY_PS_CODE == psCode)) {
            
            psBuys.append(psBuyModel(psId: buys[PS_BUY_ID], psCode: buys[PS_BUY_PS_CODE], psDate: buys[PS_BUY_DATE], psCount: buys[PS_BUY_QUANTITY], psPrice: buys[PS_BUY_PRICE]))
        }
        return psBuys
    }
    
    func updatePsBuy(buyCode:Int ,newPrice:Double , newCount:Double , newDate:String){
        
        let ps = tblPsBuy.filter(PS_BUY_ID == buyCode)
        try! db.run(ps.update(PS_BUY_PRICE <- newPrice ,PS_BUY_QUANTITY <- newCount ,PS_BUY_DATE <- newDate ))
    }
    
    
    func deletePsBuy(buyCode:Int){
        
        let ps = tblPsBuy.filter(PS_BUY_ID == buyCode )
        try! db.run(ps.delete())
     
    }
}
