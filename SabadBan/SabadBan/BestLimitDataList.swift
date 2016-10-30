//
//	BestLimitDataList.swift
//
//	Create by Morteza Gharedaghi on 6/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - BestLimitDataList

public struct BestLimitDataList: Glossy {

    public let buyNumber: Int!
    public let buyPrice: Int!
    public let buyValue: Int!
    public let number: Int!
    public let sellNumber: Int!
    public let sellPrice: Int!
    public let sellValue: Int!

    //MARK: Decodable
    public init?(json: JSON) {
        buyNumber = "buyNumber" <~~ json
        buyPrice = "buyPrice" <~~ json
        buyValue = "buyValue" <~~ json
        number = "number" <~~ json
        sellNumber = "sellNumber" <~~ json
        sellPrice = "sellPrice" <~~ json
        sellValue = "sellValue" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "buyNumber" ~~> buyNumber,
                "buyPrice" ~~> buyPrice,
                "buyValue" ~~> buyValue,
                "number" ~~> number,
                "sellNumber" ~~> sellNumber,
                "sellPrice" ~~> sellPrice,
                "sellValue" ~~> sellValue,
        ])
    }

}
