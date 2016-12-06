//
//	PushNotificationAlarmData.swift
//
//	Create by PC22 on 5/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - PushNotificationAlarmData
public struct PushNotificationAlarmData: Glossy {
    
    public let active : Bool!
    public let alarmPrice : Int!
    public let atPrice : Int!
    public let descriptionField : String!
    public let email : String!
    public let id : Int!
    public let orderType : String!
    public let symbolCode : Int64!
    public let symbolShortNameEn : String!
    public let symbolShortNameFa : String!
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        active = "active" <~~ json
        alarmPrice = "alarmPrice" <~~ json
        atPrice = "atPrice" <~~ json
        descriptionField = "description" <~~ json
        email = "email" <~~ json
        id = "id" <~~ json
        orderType = "orderType" <~~ json
        symbolCode = "symbolCode" <~~ json
        symbolShortNameEn = "symbolShortNameEn" <~~ json
        symbolShortNameFa = "symbolShortNameFa" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "active" ~~> active,
            "alarmPrice" ~~> alarmPrice,
            "atPrice" ~~> atPrice,
            "description" ~~> descriptionField,
            "email" ~~> email,
            "id" ~~> id,
            "orderType" ~~> orderType,
            "symbolCode" ~~> symbolCode,
            "symbolShortNameEn" ~~> symbolShortNameEn,
            "symbolShortNameFa" ~~> symbolShortNameFa,
            ])
    }
    
}