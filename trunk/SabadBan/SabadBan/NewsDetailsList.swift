//
//	NewsDetailsList.swift
//
//	Create by Morteza Gharedaghi on 7/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - NewsDetailsList

public struct NewsDetailsList: Glossy {

    public let newsReport: String!
    public let newsTime: String!
    public let newsTitle: String!
    public let symbolCode: AnyObject!
    public let symbolNameEn: AnyObject!
    public let symbolNameFa: AnyObject!

    //MARK: Decodable
    public init?(json: JSON) {
        newsReport = "newsReport" <~~ json
        newsTime = "newsTime" <~~ json
        newsTitle = "newsTitle" <~~ json
        symbolCode = "symbolCode" <~~ json
        symbolNameEn = "symbolNameEn" <~~ json
        symbolNameFa = "symbolNameFa" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "newsReport" ~~> newsReport,
                "newsTime" ~~> newsTime,
                "newsTitle" ~~> newsTitle,
                "symbolCode" ~~> symbolCode,
                "symbolNameEn" ~~> symbolNameEn,
                "symbolNameFa" ~~> symbolNameFa,
        ])
    }
    
    public func convertTime(color: UIColor) -> NSMutableAttributedString {
        
        let dateFormatter = NSDateFormatter()
        let combination = NSMutableAttributedString()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(self.newsTime)
        
        if let font = UIFont(name: AppFontName_IranSans, size: (14.5)) {
            let firstAtt = [NSForegroundColorAttributeName: color, NSFontAttributeName: font]
            let secondAtt = [NSForegroundColorAttributeName: AppMainColor, NSFontAttributeName: UIFont.systemFontOfSize(1)]
            let partTwo = NSMutableAttributedString(string: " p", attributes: secondAtt)
            let partThree = NSMutableAttributedString(string: convertToPersianDateWithTime(date!), attributes: firstAtt)
            
            combination.appendAttributedString(partTwo)
            combination.appendAttributedString(partThree)
        }
        
        return combination
    }

}
