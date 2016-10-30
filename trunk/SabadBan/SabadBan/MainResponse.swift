//
//  MainResponse.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/6/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
import Gloss

//MARK: - Indexs

public struct MainResponse<T:Glossy>: Glossy {

    public let errorCode: AnyObject!
    public let errorDescription: AnyObject!
    public let response: T!
    public let successful: Bool!
    public let updateLatest: String!
    //MARK: Decodable
    public init?(json: JSON) {
        errorCode = "errorCode" <~~ json
        errorDescription = "errorDescription" <~~ json
        response = "response" <~~ json
        successful = "successful" <~~ json
        updateLatest = "updateLatest" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "errorCode" ~~> errorCode,
                "errorDescription" ~~> errorDescription,
                "response" ~~> response,
                "successful" ~~> successful,
                "updateLatest" ~~> updateLatest
        ])
    }

    public func convertTime() -> NSMutableAttributedString {


        let dateFormatter = NSDateFormatter()
        let combination = NSMutableAttributedString()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = dateFormatter.dateFromString(self.updateLatest)


        if let font = UIFont(name: AppFontName_IranSans, size: (12)) {
            let firstAtt = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: font]
            let secondAtt = [NSForegroundColorAttributeName: AppMainColor, NSFontAttributeName: UIFont.systemFontOfSize(1)]
            let partOne = NSMutableAttributedString(string: Strings.lastUpdate.localized(), attributes: firstAtt)
            let partTwo = NSMutableAttributedString(string: " p", attributes: secondAtt)
            let partThree = NSMutableAttributedString(string: convertToPersianDateWithTime(date!), attributes: firstAtt)


            combination.appendAttributedString(partOne)
            combination.appendAttributedString(partTwo)
            combination.appendAttributedString(partThree)
        }

        return combination
    }
}
