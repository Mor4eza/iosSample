//
//	SymbolNameResponse.swift
//
//	Create by Morteza Gharedaghi on 5/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - SymbolNameResponse

public struct SymbolNameResponse: Glossy {

    public let pageNumber: Int!
    public let recordPerPage: Int!
    public let supportPaging: Bool!
    public let symbolNameList: [SymbolNameList]!
    public let totalPages: Int!

    //MARK: Decodable
    public init?(json: JSON) {
        pageNumber = "pageNumber" <~~ json
        recordPerPage = "recordPerPage" <~~ json
        supportPaging = "supportPaging" <~~ json
        symbolNameList = "symbolNameList" <~~ json
        totalPages = "totalPages" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "pageNumber" ~~> pageNumber,
                "recordPerPage" ~~> recordPerPage,
                "supportPaging" ~~> supportPaging,
                "symbolNameList" ~~> symbolNameList,
                "totalPages" ~~> totalPages,
        ])
    }

}
