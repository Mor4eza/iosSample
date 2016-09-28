//
//  AppConstants.swift
//  M-TraderPro
//
//  Created by Morteza Gharedaghi on 8/22/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit

public let LanguageChangedNotification = "languageChanged"
public let NetworkErrorAlert = "networkError"
public let PortfolioEdited = "PortfolioEdited"
public let AppFontName_IranSans = "IRANSansMobileFaNum"
public let AppTadbirUrl = "http://185.37.52.193:9090"
public let AppNewsURL = "http://sabadbannewstest.sefryek.com"
public let ServicesHeaders = ["Content-Type": "application/json"]

//MARK: - Urls
public let URLS:[String:String] =
    ["IndexListAndDetails":"/services/getIndexListAndDetails",
     "getSymbolListByIndex":"/services/getSymbolListByIndex",
     "getSymbolListAndDetails":"/services/getSymbolListAndDetails",
     "getBestLimitsBySymbol":"/services/getBestLimitsBySymbol",
     "getSymbolTradingDetails":"/services/getSymbolTradingDetails",
     "getNewsListAndDetails" : "/services/getNewsListAndDetails",
     "getMarketActivity" : "/services/getMarketActivity",
     "getBourseNews" : "/api/v1/news/get",
     "login" : "/api/v1/auth/login",
     "register" : "/api/v1/auth/register"]

//MARK:- Constants
public var SelectedIndexCode:String = ""
public var SelectedSymbolCode:String = ""
public var SelectedSymbolName:String = ""
public var LoginToken:String = ""
public var PushToken:String = ""
public var LogedInUserName:String = ""

//MARK: - App Style

public let AppMainColor = UIColor(netHex: 0x172340)
public let AppBarTintColor = UIColor(netHex:0x2b3a5c)
public let AppBackgroundLight = UIColor(netHex:0x2b3a5c)

//MARK: - Enums
public enum TimeFrameType : Int {
    case day = 0
    case week
    case month
    case year
}

public enum SortCondition {
    case accending
    case decending
    case notSorted
}
