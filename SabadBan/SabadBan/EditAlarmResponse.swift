//
//	EditAlarmResponse.swift
//
//	Create by Morteza Gharedaghi on 29/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - Response

public struct EditAlarmResponse: Glossy {

    public let active: Bool!
    public let alarmPrice: Float!
    public let atPrice: Float!
    public let descriptionField: String!
    public let id: Int!
    public let orderType: String!
    public let priceDirection: String!
    public let symbolCode: Int64!


    //MARK: Decodable
    public init?(json: JSON) {
        active = "active" <~~ json
        alarmPrice = "alarmPrice" <~~ json
        atPrice = "atPrice" <~~ json
        descriptionField = "description" <~~ json
        id = "id" <~~ json
        orderType = "orderType" <~~ json
        priceDirection = "priceDirection" <~~ json
        symbolCode = "symbolCode" <~~ json
    }


    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "active" ~~> active,
                "alarmPrice" ~~> alarmPrice,
                "atPrice" ~~> atPrice,
                "description" ~~> descriptionField,
                "id" ~~> id,
                "orderType" ~~> orderType,
                "priceDirection" ~~> priceDirection,
                "symbolCode" ~~> symbolCode,
        ])
    }

}