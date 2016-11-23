//
//	SymbolNameList.swift
//
//	Create by Morteza Gharedaghi on 5/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - SymbolNameList

public struct SymbolNameList: Glossy {

    public let symbolCode: Int64!
    public let symbolCompleteName: String!
    public let symbolShortName: String!

    //MARK: Decodable
    public init?(json: JSON) {
        symbolCode = "symbolCode" <~~ json
        symbolCompleteName = "symbolCompleteName" <~~ json
        symbolShortName = "symbolShortName" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "symbolCode" ~~> symbolCode,
                "symbolCompleteName" ~~> symbolCompleteName,
                "symbolShortName" ~~> symbolShortName,
        ])
    }

}
