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

}
