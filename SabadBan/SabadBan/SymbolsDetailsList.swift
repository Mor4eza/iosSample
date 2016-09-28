//
//	SymbolDetailsList.swift
//
//	Create by Morteza Gharedaghi on 31/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - SymbolDetailsList
public struct SymbolsDetailsList: Glossy {

	public let baseValue : Double!
	public let benchmarkBuy : Float!
	public let benchmarkSales : Float!
	public let buyValue : Float!
	public let closePrice : Float!
	public let closePriceChange : Double!
	public let closePriceYesterday : Float!
	public let descriptionField : AnyObject!
	public let eps : Double!
	public let highPrice : Float!
	public let lastTradeDate : String!
	public let lastTradePrice : Float!
	public let lastTradePriceChange : Float!
	public let lastTradePriceChangePercent : Float!
	public let lowPrice : Float!
	public let marketValue : Double!
	public let openPrice : Float!
	public let pe : Double!
	public let status : String!
	public let symbolCode : String!
	public let symbolCompleteNameFa : String!
	public let symbolNameEn : String!
	public let symbolNameFa : String!
	public let todayPrice : Double!
	public let todayProfit : Double!
	public let totalProfit : Double!
	public let transactionNumber : Float!
	public let transactionVolume : Float!

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
		symbolCompleteNameFa = "symbolCompleteNameFa" <~~ json
		symbolNameEn = "symbolNameEn" <~~ json
		symbolNameFa = "symbolNameFa" <~~ json
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
		"symbolCompleteNameFa" ~~> symbolCompleteNameFa,
		"symbolNameEn" ~~> symbolNameEn,
		"symbolNameFa" ~~> symbolNameFa,
		"todayPrice" ~~> todayPrice,
		"todayProfit" ~~> todayProfit,
		"totalProfit" ~~> totalProfit,
		"transactionNumber" ~~> transactionNumber,
		"transactionVolume" ~~> transactionVolume,
		])
	}

}
