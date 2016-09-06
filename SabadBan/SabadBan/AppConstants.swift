//
//  AppConstants.swift
//  M-TraderPro
//
//  Created by Morteza Gharedaghi on 8/22/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit

public let LanguageChangedNotification = "languageChanged"
public let AppFontName_IranSans = "IRANSansMobileFaNum"
public let AppTadbirUrl = "http://185.37.52.193:9090"
public let ServicesHeaders = ["Content-Type": "application/json"]

public let URLS:[String:String] =
    ["IndexListAndDetails":"/services/getIndexListAndDetails",
     "getSymbolListByIndex":"/services/getSymbolListByIndex",
     "getSymbolListAndDetails":"/services/getSymbolListAndDetails",
     "getBestLimitsBySymbol":"/services/getBestLimitsBySymbol",
     "getSymbolTradingDetails":"/services/getSymbolTradingDetails"
    ]

public var SelectedIndexCode:String = "0"
public var SelectedSymbolCode:String = "0"

//Mark :- App Style 

public let AppMainColor = UIColor(netHex: 0x172340)
public let AppBarTintColor = UIColor(netHex:0x2b3a5c)
public let AppBackgroundLight = UIColor(netHex:0x2b3a5c)