//
//	CheckVersionCodeResponse.swift
//
//	Create by PC22 on 23/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - Response

public struct CheckVersionCodeResponse: Glossy {

    public let descriptionEn: String!
    public let descriptionFa: String!
    public let upToDate: Bool!
    public let updateLink: String!
    public let updateTimer: Int!


    //MARK: Decodable
    public init?(json: JSON) {
        descriptionEn = "descriptionEn" <~~ json
        descriptionFa = "descriptionFa" <~~ json
        upToDate = "upToDate" <~~ json
        updateLink = "updateLink" <~~ json
        updateTimer = "updateTimer" <~~ json
    }


    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "descriptionEn" ~~> descriptionEn,
                "descriptionFa" ~~> descriptionFa,
                "upToDate" ~~> upToDate,
                "updateLink" ~~> updateLink,
                "updateTimer" ~~> updateTimer,
        ])
    }

}