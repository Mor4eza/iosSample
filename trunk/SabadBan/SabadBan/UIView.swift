//
//  UIView.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/17/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import Localize_Swift

extension UILabel {
    
    func changeDirection() {
        if (getAppLanguage() == "fa"){
            self.textAlignment = .Right
        }else if (getAppLanguage() == "en") {
            self.textAlignment = .Left
        }
    }
    
    func setDefaultFont(){
        self.font = UIFont(name: AppFontName_IranSans, size:self.font.pointSize)
    }
    
}

extension UIButton {
    
    func changeDirection() {
        if (getAppLanguage() == "fa"){
            self.titleLabel!.textAlignment = .Right
        }else if (getAppLanguage() == "en") {
            self.titleLabel!.textAlignment = .Left
        }
    }
    
    func setDefaultFont(){
        self.titleLabel?.font = UIFont(name: AppFontName_IranSans, size:(self.titleLabel?.font.pointSize)!)
    }
}

extension UITextField {
    
    func changeDirection() {
        if (getAppLanguage() == "fa"){
            self.textAlignment = .Right
        }else if (getAppLanguage() == "en") {
            self.textAlignment = .Left
        }
        
    }
}

extension UIViewController {
    
    func setFontFamily(fontFamily: String, forView view: UIView, andSubViews isSubViews: Bool) {
        if (view is UILabel) {
            let lbl = (view as! UILabel)
            lbl.font = UIFont(name: fontFamily, size: lbl.font.pointSize)
        }else if (view is UIButton) {
            let btn = (view as! UIButton)
            btn.titleLabel?.font = UIFont(name: fontFamily, size: btn.titleLabel!.font.pointSize)
        }

        if isSubViews {
            for sview: UIView in view.subviews {
                self.setFontFamily(fontFamily, forView: sview, andSubViews: true)
            }
        }
    }
}