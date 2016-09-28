//
//  NumbersFormat.swift
//  M-TraderPro
//
//  Created by Morteza Gharedaghi on 8/21/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import Foundation

extension NSNumber {

    func currencyFormat(decimalDigits : Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.currencyDecimalSeparator = "."
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        var decimalPart = self as Double
        decimalPart = decimalPart - Double(Int(decimalPart))

        if (decimalPart == 0) {
            formatter.minimumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 1
        }

        formatter.maximumFractionDigits = decimalDigits
        let priceString = formatter.stringFromNumber(self)
        return priceString!
    }

}

extension Int {

    func currencyFormat(decimalDigits : Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        formatter.currencyDecimalSeparator = "."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        let priceString = formatter.stringFromNumber(self)
        return priceString!
    }

    func addZero() -> String {
        return (self < 10 ? "0\(self)" : "\(self)")
    }
}

extension Float {

    func currencyFormat(decimalDigits : Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        formatter.currencyDecimalSeparator = "."

        let decimalPart = self - Float(Int(self))

        if (decimalPart == 0) {
            formatter.minimumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 1
        }

        formatter.maximumFractionDigits = decimalDigits
        let priceString = formatter.stringFromNumber(self)
        return priceString!
    }
}

extension Double {

    func currencyFormat(decimalDigits : Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        formatter.currencyDecimalSeparator = "."

        let decimalPart = self - Double(Int(self))

        if (decimalPart == 0) {
            formatter.minimumFractionDigits = 0
        } else {
            formatter.minimumFractionDigits = 1
        }

        formatter.maximumFractionDigits = decimalDigits
        let priceString = formatter.stringFromNumber(self)
        return priceString!
    }

    func suffixNumber() -> String {

        var num:Double = self;
        let sign = ((num < 0) ? "-" : "" );

        num = fabs(num);

        if (num < 1000.0){
            return "\(sign)\(num)";
        }

        var exp:Int = Int(log10(num) / 3.0 ); //log10(1000));

        let units:[String] = ["K","M","B","T","P","E"];

        if (exp > 3) {
            exp = 3
        }

        let roundedNum = (num / pow(1000.0,Double(exp))).currencyFormat(3)

        return "\(sign)\(roundedNum)\(units[exp-1])";
    }

}
