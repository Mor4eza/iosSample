//
//	SymbolDetailsList.swift
//
//	Create by Morteza Gharedaghi on 29/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - SymbolDetailsList
public struct SymbolDetailsList: Glossy {

    public let baseValue : Double!
    public let benchmarkBuy : Double!
    public let benchmarkSales : Double!
    public let buyValue : Double!
    public let closePrice : Double!
    public let closePriceChange : Double!
    public let closePriceYesterday : Double!
    public let descriptionField : AnyObject!
    public let eps : Double!
    public let highPrice : Double!
    public let lastTradeDate : AnyObject!
    public let lastTradePrice : Double!
    public let lastTradePriceChange : Double!
    public let lastTradePriceChangePercent : Double!
    public let lowPrice : Double!
    public let marketValue : Double!
    public let openPrice : Double!
    public let pe : Double!
    public let status : String!
    public let symbolCode : Int64!
    public let symbolCompleteName : String!
    public let symbolShortName : String!
    public let todayPrice : Double!
    public let todayProfit : Float!
    public let totalProfit : Float!
    public let transactionNumber : Double!
    public let transactionVolume : Double!



    //MARK: Decodable
    public init?(json: JSON){
        baseValue = "baseValue" <~~ json
        benchmarkBuy = "benchmarkBuy" <~~ json
        benchmarkSales = "benchmarkSales" <~~ json
        buyValue = "buyValue" <~~ json
        closePrice = "closePrice" <~~ json
        closePriceChange = "closePriceChange" <~~ json
        closePriceYesterday = "closePriceYesterday" <~~ json
        descriptionField = "description" <~~ json
        eps = "eps" <~~ json
        highPrice = "highPrice" <~~ json
        lastTradeDate = "lastTradeDate" <~~ json
        lastTradePrice = "lastTradePrice" <~~ json
        lastTradePriceChange = "lastTradePriceChange" <~~ json
        lastTradePriceChangePercent = "lastTradePriceChangePercent" <~~ json
        lowPrice = "lowPrice" <~~ json
        marketValue = "marketValue" <~~ json
        openPrice = "openPrice" <~~ json
        pe = "pe" <~~ json
        status = "status" <~~ json
        symbolCode = "symbolCode" <~~ json
        symbolCompleteName = "symbolCompleteName" <~~ json
        symbolShortName = "symbolShortName" <~~ json
        todayPrice = "todayPrice" <~~ json
        todayProfit = "todayProfit" <~~ json
        totalProfit = "totalProfit" <~~ json
        transactionNumber = "transactionNumber" <~~ json
        transactionVolume = "transactionVolume" <~~ json
    }


    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "baseValue" ~~> baseValue,
            "benchmarkBuy" ~~> benchmarkBuy,
            "benchmarkSales" ~~> benchmarkSales,
            "buyValue" ~~> buyValue,
            "closePrice" ~~> closePrice,
            "closePriceChange" ~~> closePriceChange,
            "closePriceYesterday" ~~> closePriceYesterday,
            "description" ~~> descriptionField,
            "eps" ~~> eps,
            "highPrice" ~~> highPrice,
            "lastTradeDate" ~~> lastTradeDate,
            "lastTradePrice" ~~> lastTradePrice,
            "lastTradePriceChange" ~~> lastTradePriceChange,
            "lastTradePriceChangePercent" ~~> lastTradePriceChangePercent,
            "lowPrice" ~~> lowPrice,
            "marketValue" ~~> marketValue,
            "openPrice" ~~> openPrice,
            "pe" ~~> pe,
            "status" ~~> status,
            "symbolCode" ~~> symbolCode,
            "symbolCompleteName" ~~> symbolCompleteName,
            "symbolShortName" ~~> symbolShortName,
            "todayPrice" ~~> todayPrice,
            "todayProfit" ~~> todayProfit,
            "totalProfit" ~~> totalProfit,
            "transactionNumber" ~~> transactionNumber,
            "transactionVolume" ~~> transactionVolume,
            ])
    }
    
}