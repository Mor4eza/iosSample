//
//	Response.swift
//
//	Create by Morteza Gharedaghi on 6/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - SymbolBestLimitResponse

public struct SymbolBestLimitResponse: Glossy {

    public let bestLimitDataList: [BestLimitDataList]!
    public let symbolCode: Int64!

    //MARK: Decodable
    public init?(json: JSON) {
        bestLimitDataList = "bestLimitDataList" <~~ json
        symbolCode = "symbolCode" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "bestLimitDataList" ~~> bestLimitDataList,
                "symbolCode" ~~> symbolCode,
        ])
    }

}
