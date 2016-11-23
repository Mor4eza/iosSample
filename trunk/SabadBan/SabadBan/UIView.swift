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
        if (getAppLanguage() == Language.fa.rawValue) {
            self.textAlignment = .Right
        } else if (getAppLanguage() == Language.en.rawValue) {
            self.textAlignment = .Left
        }
    }

    func setDefaultFont(size: CGFloat? = nil) {
        if size != nil {
            self.font = UIFont(name: AppFontName_IranSans, size: (size!))
        } else {
            self.font = UIFont(name: AppFontName_IranSans, size: (self.font.pointSize - 3))
        }
    }

}

extension UIButton {

    func changeDirection() {
        if (getAppLanguage() == Language.fa.rawValue) {
            self.titleLabel!.textAlignment = .Right
        } else if (getAppLanguage() == Language.en.rawValue) {
            self.titleLabel!.textAlignment = .Left
        }
    }

    func setDefaultFont() {
        self.titleLabel?.font = UIFont(name: AppFontName_IranSans, size: (self.titleLabel?.font.pointSize)!)
    }
}


private var maxLengths = [UITextField: Int]()
private var haveComma = [UITextField: Bool]()
private var allowedCharacters = [UITextField: String]()
private var previousText = String()

extension UITextField {

    func changeDirection() {
        if (getAppLanguage() == Language.fa.rawValue) {
            self.textAlignment = .Right
        } else if (getAppLanguage() == Language.en.rawValue) {
            self.textAlignment = .Left
        }

    }

    func setDefaultFont() {
        self.font = UIFont(name: AppFontName_IranSans, size: self.font!.pointSize)
    }

    @IBInspectable var maxLength: Int {
        get {

            guard let length = maxLengths[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxLengths[self] = newValue

            addTarget(
                    self,
                    action: #selector(textFieldPropertyEditor),
                    forControlEvents: UIControlEvents.EditingChanged
                    )
        }
    }

    @IBInspectable var commaSeperator: Bool {
        get {

            guard let haveComma = haveComma[self] else {
                return false
            }
            return haveComma
        }
        set {
            haveComma[self] = newValue

            addTarget(
                    self,
                    action: #selector(textFieldPropertyEditor),
                    forControlEvents: UIControlEvents.EditingChanged
                    )
        }
    }

    @IBInspectable var allowedCharacter: String {
        get {

            guard let allowedCharacters = allowedCharacters[self] else {
                return ""
            }
            return allowedCharacters
        }
        set {
            allowedCharacters[self] = newValue

            addTarget(
                    self,
                    action: #selector(textFieldPropertyEditor),
                    forControlEvents: UIControlEvents.EditingChanged
                    )
        }
    }


    func textFieldPropertyEditor(textField: UITextField) {

        if let enteredAllowedCharacters = allowedCharacters[textField] {
            if enteredAllowedCharacters.characters.count > 0 {
                if let enteredText = textField.text {
                    if !(enteredText.isEmpty) {
                        let lastCharacter: Character = enteredText[(enteredText.characters.count - 1)]
                        guard allowedCharacter.characters.contains(lastCharacter) else {
                            var finalText = String()
                            var textCharacters = enteredText.characters
                        
                            if (previousText.characters.count < enteredText.characters.count) {
                                textCharacters.removeLast()
                            }

                            for character in textCharacters {
                                finalText += String(character)
                            }
                            text = finalText
                            previousText = finalText
                            return
                        }
                    }
                }
            }
        }

        let doesHaveComma = haveComma[textField]

        guard let prospectiveText = textField.text
        where prospectiveText.characters.count > maxLength else {
            if (doesHaveComma != nil) {
                if let enteredText = text {
                    guard !enteredText.isEmpty else {
                        return
                    }
                    var numberString = String()
                    var characterArray = enteredText.characters
                    characterArray.removeLast()
                    for character in characterArray {

                        if let number = String(character).getCurrencyNumber() {
                            numberString += String(number)
                        }

                    }
                    if !numberString.isEmpty {
                        numberString = String(numberString.getCurrencyNumber()!)
                    }

                    numberString += String(enteredText[enteredText.characters.count - 1])
                    if let resutText = numberString.getCurrencyNumber()?.currencyFormat(0) {
                        text = resutText
                    }
                }
            }

            return
        }
        if (doesHaveComma != nil) {
            text = prospectiveText.substringWithRange(
                    Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength + 1))
                    )
        } else {
            text = prospectiveText.substringWithRange(
                    Range<String.Index>(prospectiveText.startIndex ..< prospectiveText.startIndex.advancedBy(maxLength))
                    )
        }
    }

}

extension UITextView {

    func changeDirection() {
        if (getAppLanguage() == Language.fa.rawValue) {
            self.textAlignment = .Right
        } else if (getAppLanguage() == Language.en.rawValue) {
            self.textAlignment = .Left
        }
    }

    func setDefaultFont() {
        self.font = UIFont(name: AppFontName_IranSans, size: self.font!.pointSize)
    }

}

extension UIViewController {

    func setFontFamily(fontFamily: String, forView view: UIView, andSubViews isSubViews: Bool) {
        if (view is UILabel) {
            let lbl = (view as! UILabel)
            lbl.font = UIFont(name: fontFamily, size: lbl.font.pointSize)
        } else if (view is UIButton) {
            let btn = (view as! UIButton)
            btn.titleLabel?.font = UIFont(name: fontFamily, size: btn.titleLabel!.font.pointSize)
        } else if (view is UITextView) {
            let txt = (view as! UITextView)
            txt.font = UIFont(name: fontFamily, size: txt.font!.pointSize)
        }

        if isSubViews {
            for sview: UIView in view.subviews {
                self.setFontFamily(fontFamily, forView: sview, andSubViews: true)
            }
        }
    }
}

extension UIView {

    //Round Corners in Interface Biulder
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(CGColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
    }

}

extension UISearchBar {
    public func setSerchTextcolor(color: UIColor) {
        let clrChange = subviews.flatMap {
            $0.subviews
        }
        guard let sc = (clrChange.filter {
            $0 is UITextField
        }).first as? UITextField else {
            return
        }
        sc.textColor = color
    }
}

