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
public let TimeOutErrorAlert = "TimeOutError"
public let ServerErrorAlert = "ServerError"
public let BestBuyClosed = "BestBuyClosed"
public let symbolSelected = "SYMBOL_SELECTED"
public let PortfolioEdited = "PortfolioEdited"
public let AppFontName_IranSans = "IRANSansMobileFaNum"
public let AcraUrl = "http://acra.sefryek.com:5984/acra-p343-sabadban-ios/_design/acra-storage/_update/report"
public let AppNewsURL = "http://sabadbannewstest.sefryek.com"
public let ServicesHeaders = ["Content-Type": "application/json"]
public var GuestUser = "1@1.com"
public var GuestPass = "12345678"
public var isGuest = false
public var updateServiceInterval = 300.0


#if DEV
    public let AppTadbirUrl = "http://sabadban.sefryek.com:9091" //Server 6 Test

#elseif TEST
    public let AppTadbirUrl = "http://sabadban.sefryek.com:9091" //Server 6 Test

#else 
    public let AppTadbirUrl = "http://sabadban.sefryek.com:9090" //Server 6 Prod
#endif

//MARK: - Urls
public let URLS:[String:String] =
    ["IndexListAndDetails":"/services/getIndexListAndDetails",
     "getSymbolListByIndex":"/services/getSymbolListByIndex",
     "getSymbolListAndDetails":"/services/getSymbolListAndDetails",
     "getBestLimitsBySymbol":"/services/getBestLimitsBySymbol",
     "getSymbolTradingDetails":"/services/getSymbolTradingDetails",
     "getNewsListAndDetails" : "/services/getNewsListAndDetails",
     "getMarketActivity" : "/services/getMarketActivity",
     "getSymbolNameList" : "/services/getSymbolNameList",
     "getBourseNews" : "/api/v1/news/get",
     "login" : "/api/v1/auth/login",
     "logout" : "/api/v1/auth/logout",
     "guestLogin" : "/api/v1/auth/login/guest",
     "register" : "/api/v1/auth/register",
     "sendContactUs" : "/api/v1/tools/contact_us",
     "changePassword" : "/api/v1/auth/changePassword",
     "checkVersionCode" : "/services/checkVersionCode"
]

//MARK:- Constants
public var SelectedIndexCode:String = ""
public var SelectedSymbolCode:Int64 = 0
public var SelectedSymbolName:String = ""
public var LoginToken:String = ""
public var PushToken:String = ""
public var LogedInUserName:String = ""
public var LogedInUserId:Int = -1

//MARK: - App Style

public let AppMainColor = UIColor(netHex: 0x172340)
public let AppBarTintColor = UIColor(netHex:0x2b3a5c)
public let AppBackgroundLight = UIColor(netHex:0x2b3a5c)

//MARK: - Language
public let LocaleFa = "fa_IR"

//MARK: - defaults
public let UserName: String = "UserName"
public let GuestUserName: String = "GuestUserName"
public let Password: String = "Password"
public let GuestPassword: String = "GuestPassword"
public let HINT = "HINT"
public let JailBreakAccept = "JailBreakAccept"

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

public enum Language: String {
    case fa = "fa"
    case en = "en"
}
