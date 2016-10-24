//
//  Utils.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/17/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import Foundation
import Localize_Swift

let IOS_VERSION = CFloat(UIDevice.currentDevice().systemVersion)!
public func getAppLanguage() -> String {
    return Localize.currentLanguage()
}

let appVersionName = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String
let appVersionCode = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String
let appPackageName = NSBundle.mainBundle().bundleIdentifier

var isSimulator: Bool {
    return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
}

var buildDate:NSDate
{
    if let infoPath = NSBundle.mainBundle().pathForResource("Info.plist", ofType: nil),
        let infoAttr = try? NSFileManager.defaultManager().attributesOfItemAtPath(infoPath),
        let infoDate = infoAttr["NSFileCreationDate"] as? NSDate
    { return infoDate }
    return NSDate()
}

func persianStringCompare(value1: String, value2: String) -> Bool {
    // One string is alphabetically first.
    // ... True means value1 precedes value2.
    let unicodeValueList  = [1570, 1575, 1576, 1662, 1578, 1579, 1580, 1670, 1581, 1582, 1583, 1584, 1585, 1586, 1688, 1587, 1588, 1589, 1590, 1591, 1592, 1593, 1594, 1601, 1602, 1705, 1603, 1711, 1604, 1605, 1606, 1608, 1607, 1740, 1610]
    let longerText : String
    let shorterText : String
    var firstIsLonger : Bool
    if value1.characters.count > value2.characters.count {
        firstIsLonger = true
        longerText = value1
        shorterText = value2
    } else {
        firstIsLonger = false
        longerText = value2
        shorterText = value1
    }

    for i in 0..<shorterText.characters.count {
        let word1 : String = shorterText[i]
        let word2 : String = longerText[i]

        let indexWord1 = unicodeValueList.indexOf(Int(word1.unicodeScalars[word1.unicodeScalars.startIndex].value))
        let indexWord2 = unicodeValueList.indexOf(Int(word2.unicodeScalars[word2.unicodeScalars.startIndex].value))

        if indexWord1 > indexWord2{
            return firstIsLonger
        } else if indexWord1 != indexWord2 {
            return !firstIsLonger
        }
    }

    return false;
}

func convertToPersianDate(date: NSDate) -> String {
    
    let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierPersian)
    let currentDayInt = (calendar?.component(NSCalendarUnit.Day, fromDate: date))!
    let currentMonthInt = (calendar?.component(NSCalendarUnit.Month, fromDate: date))!
    let currentYearInt = (calendar?.component(NSCalendarUnit.Year, fromDate: date))!
    
    return "\(currentYearInt)/\(currentMonthInt.addZero())/\(currentDayInt.addZero())"
}

func convertToPersianDateWithTime(date: NSDate) -> String {
    
    let calendar = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierPersian)
    let currentDayInt = (calendar?.component(NSCalendarUnit.Day, fromDate: date))!
    let currentMonthInt = (calendar?.component(NSCalendarUnit.Month, fromDate: date))!
    let currentYearInt = (calendar?.component(NSCalendarUnit.Year, fromDate: date))!
    let hour = (calendar?.component(NSCalendarUnit.Hour, fromDate: date))!
    let minute = (calendar?.component(NSCalendarUnit.Minute, fromDate: date))!
    
    
    return "\(currentYearInt.addZero())/\(currentMonthInt.addZero())/\(currentDayInt) \(hour.addZero()):\(minute.addZero())"
}

func isJailbroken() -> Bool {
    var errorHappend = false
    let jailString = "Jail Test"
    do {
        try jailString.writeToFile("/private/jailbreak.txt", atomically: true, encoding: NSUTF8StringEncoding)
    }
    catch _ {
        errorHappend = true
    }
    if NSFileManager.defaultManager().fileExistsAtPath("/Applications/Cydia.app") {
        return true
    }
    else if NSFileManager.defaultManager().fileExistsAtPath("/Library/MobileSubstrate/MobileSubstrate.dylib") {
        return true
    }
    else if NSFileManager.defaultManager().fileExistsAtPath("/usr/bash") {
        return true
    }
    else if NSFileManager.defaultManager().fileExistsAtPath("/usr/sbin/sshd") {
        return true
    }
    else if NSFileManager.defaultManager().fileExistsAtPath("/etc/apt") {
        return true
    }
    else if !errorHappend {
        do {
            try NSFileManager.defaultManager().removeItemAtPath("/private/jailbreak.txt")
        }
        catch _ {
        }
        return true
    }
    
    return false
}

import FCAlertView
public class Utils {

    public static func ShowAlert(inView:UIViewController, title:String , details:String ,image:UIImage? = nil ,btnOkTitle:String? = nil , btnTitles:[String]? = nil ,tag:Int? = nil,delegate:FCAlertViewDelegate? = nil) -> FCAlertView  {

        let alert = FCAlertView()
        var okTitle = btnOkTitle
        alert.makeAlertTypeCaution()
        alert.colorScheme = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1)
        if tag != nil {
            alert.tag = tag!
        }
        if btnOkTitle == nil {
            okTitle = Strings.Ok.localized()
        }
        alert.delegate = delegate
        alert.showAlertInView(inView,
                              withTitle:title,
                              withSubtitle:details,
                              withCustomImage:image,
                              withDoneButtonTitle:okTitle,
                              andButtons:btnTitles) // Set your button titles here
        inView.view.endEditing(true)
        
        return alert
    }
}
