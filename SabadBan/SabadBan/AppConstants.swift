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
public let ServicesHeaders = ["Content-Type": "application/json"]
public var GuestUser = "1@1.com"
public var GuestPass = "12345678"

public var isGuest: Bool {
get {
    return NSUserDefaults.standardUserDefaults().boolForKey(isGuestUser)
}

set {
    NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: isGuestUser)
}
}

public var updateServiceInterval = 300.0


#if DEV
    public let AppTadbirUrl = "http://sabadban.sefryek.com:9091" //Server 6 Test
    public let AppNewsURL = "http://sabadbannewstest.sefryek.com"
    
#elseif TEST
    public let AppTadbirUrl = "http://sabadban.sefryek.com:9091" //Server 6 Test
    public let AppNewsURL = "http://sabadbannewstest.sefryek.com"
    
#else
    public let AppTadbirUrl = "http://sabadban.sefryek.com:9090" //Server 6 Prod
    public let AppNewsURL = "http://sabadbannews.sefryek.com"
#endif

//MARK: - Urls
public let URLS: [String: String] =
    ["IndexListAndDetails": "/services/getIndexListAndDetails",
     "getSymbolListByIndex": "/services/getSymbolListByIndex",
     "getSymbolListAndDetails": "/services/getSymbolListAndDetails",
     "getBestLimitsBySymbol": "/services/getBestLimitsBySymbol",
     "getSymbolTradingDetails": "/services/getSymbolTradingDetails",
     "getNewsListAndDetails": "/services/getNewsListAndDetails",
     "getMarketActivity": "/services/getMarketActivity",
     "getSymbolNameList": "/services/getSymbolNameList",
     "getBourseNews": "/api/v1/news/get",
     "login": "/api/v1/auth/login",
     "logout": "/api/v1/auth/logout",
     "guestLogin": "/api/v1/auth/login/guest",
     "register": "/api/v1/auth/register",
     "sendContactUs": "/api/v1/tools/contact_us",
     "changePassword": "/api/v1/auth/changePassword",
     "checkVersionCode": "/services/checkVersionCode",
     "getAlarmFilters": "/services/find-alarms",
     "getAlarmFiltersBySymbol": "/services/find-alarms-by-symbol",
     "addAlarmFilter": "/services/add-alarm",
     "editAlarmFilter": "/services/edit-alarm",
     "deleteAlarmFilter": "/services/delete-alarm"
]

//MARK:- Constants
public var SelectedIndexCode: String = ""
public var SelectedSymbolCode: Int64 = 0
public var SelectedSymbolLastTradePrice: Double = 0
public var SelectedSymbolName: String = ""
public var LoginToken: String = ""
public var PushToken: String = ""
public var LogedInUserName: String {
get{
    if let mUsername = NSUserDefaults.standardUserDefaults().stringForKey(LastLoggedInUserName) {
        return mUsername
    } else {
        return ""
    }
}
set {
    NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: LastLoggedInUserName)
}
}
public var LogedInUserId: Int {
get {
    if let mUserId = NSUserDefaults.standardUserDefaults().valueForKey(LastLoggedInUserId) as? Int {
        return mUserId
    } else {
        return -1
    }
    
}
set {
    NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: LastLoggedInUserId)
}
}

//MARK: - App Style

public let AppMainColor = UIColor(netHex: 0x172340)
public let AppBarTintColor = UIColor(netHex: 0x2b3a5c)
public let AppBackgroundLight = UIColor(netHex: 0x2b3a5c)

//MARK: - Language
public let LocaleFa = "fa_IR"

//MARK: - defaults
public let UserName: String = "UserName"
public let GuestUserName: String = "GuestUserName"
public let Password: String = "Password"
public let GuestPassword: String = "GuestPassword"
public let JailBreakAccept = "JailBreakAccept"
public let NumberOfLogins = "NumberOfLogins"
public let LastLoggedInUserId = "LastLoggedInUserId"
public let LastLoggedInUserName = "LastLoggedInUserName"
public let isGuestUser = "isGuestUser"

//MARK: - Error Codes
public let duplicateAlarmErrorCode = "1001"

//MARK: - Enums

public enum TimeFrameType: Int {
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
