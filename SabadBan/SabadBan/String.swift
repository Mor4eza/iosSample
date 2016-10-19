//
//  String.swift
//  SabadBan
//
//  Created by ehsan on 9/16/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

extension String {

    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }

    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func getCurrencyNumber() -> NSNumber? {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.currencyDecimalSeparator = "."
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        
        return formatter.numberFromString(self)
    }
}
