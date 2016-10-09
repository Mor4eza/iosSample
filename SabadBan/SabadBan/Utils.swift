//
//  Utils.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/17/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import Foundation
import Localize_Swift

var IOS_VERSION = CFloat(UIDevice.currentDevice().systemVersion)!
public func getAppLanguage() -> String {
    return Localize.currentLanguage()
}

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
    let biggerLength : String
    let smallerLength : String
    if value1.characters.count > value2.characters.count {
        biggerLength = value1
        smallerLength = value2
    } else {
        biggerLength = value2
        smallerLength = value1
    }

    for i in 0..<smallerLength.characters.count {
        let word1 : String = smallerLength[i]
        let word2 : String = biggerLength[i]

        let indexWord1 = unicodeValueList.indexOf(Int(word1.unicodeScalars[word1.unicodeScalars.startIndex].value))
        let indexWord2 = unicodeValueList.indexOf(Int(word2.unicodeScalars[word2.unicodeScalars.startIndex].value))

        if indexWord1 > indexWord2{
            return true
        } else if indexWord1 != indexWord2 {
            return false
        }
    }

    return false;
}

import FCAlertView
public class Utils {

    public static func ShowAlert(inView:UIViewController, title:String , details:String ,image:UIImage? = nil ,btnOkTitle:String? = nil , btnTitles:[String]? = nil ,tag:Int? = nil,delegate:FCAlertViewDelegate? = nil)  {

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
        
    }
}
