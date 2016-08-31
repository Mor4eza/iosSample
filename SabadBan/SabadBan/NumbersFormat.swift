//
//  NumbersFormat.swift
//  M-TraderPro
//
//  Created by Morteza Gharedaghi on 8/21/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import Foundation

extension NSNumber {
    
    func currencyFormat() -> String {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let priceString = formatter.stringFromNumber(self)
        return priceString!
    }
    
}

extension Double {
    
    func currencyFormat() -> String {
        let formatter = NSNumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.currencySymbol = ""
        formatter.locale = NSLocale.init(localeIdentifier: getAppLanguage())
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
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
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","B","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])";
    }
    
    
}