//
//	IndexDetailsList.swift
//
//	Create by Morteza Gharedaghi on 28/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - IndexDetailsList
public struct IndexDetailsList: Glossy {

    public let baseValue : Float!
    public let changePriceOnSameTime : Double!
    public let changePricePercentOnSameTime : Double!
    public let changePricePercentVsPreviousTime : Float!
    public let changePriceVsPreviousTime : Float!
    public let closePrice : Float!
    public let descriptionField : AnyObject!
    public let highPrice : Float!
    public let indexCode : Int64!
    public let lowPrice : Float!
    public let openPrice : Float!
    public let shortName : String!

    //MARK: Decodable
    public init?(json: JSON){
        baseValue = "baseValue" <~~ json
        changePriceOnSameTime = "changePriceOnSameTime" <~~ json
        changePricePercentOnSameTime = "changePricePercentOnSameTime" <~~ json
        changePricePercentVsPreviousTime = "changePricePercentVsPreviousTime" <~~ json
        changePriceVsPreviousTime = "changePriceVsPreviousTime" <~~ json
        closePrice = "closePrice" <~~ json
        descriptionField = "description" <~~ json
        highPrice = "highPrice" <~~ json
        indexCode = "indexCode" <~~ json
        lowPrice = "lowPrice" <~~ json
        openPrice = "openPrice" <~~ json
        shortName = "shortName" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "baseValue" ~~> baseValue,
            "changePriceOnSameTime" ~~> changePriceOnSameTime,
            "changePricePercentOnSameTime" ~~> changePricePercentOnSameTime,
            "changePricePercentVsPreviousTime" ~~> changePricePercentVsPreviousTime,
            "changePriceVsPreviousTime" ~~> changePriceVsPreviousTime,
            "closePrice" ~~> closePrice,
            "description" ~~> descriptionField,
            "highPrice" ~~> highPrice,
            "indexCode" ~~> indexCode,
            "lowPrice" ~~> lowPrice,
            "openPrice" ~~> openPrice,
            "shortName" ~~> shortName,
            ])
    }

}
