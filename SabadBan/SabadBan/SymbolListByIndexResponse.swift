//
//	SymbolListByIndexResponse.swift
//
//	Create by Morteza Gharedaghi on 26/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - SymbolListByIndexResponse
public struct SymbolListByIndexResponse: Glossy {

    public let indexCode : Int!
    public let pageNumber : Int!
    public let recordPerPage : Int!
    public let supportPaging : Bool!
    public let symbolCompleteName : String!
    public let symbolDetailsList : [SymbolDetailsList]!
    public let symbolShortName : AnyObject!
    public let timeFrameType : AnyObject!
    public let totalPages : Int!



    //MARK: Decodable
    public init?(json: JSON){
        indexCode = "indexCode" <~~ json
        pageNumber = "pageNumber" <~~ json
        recordPerPage = "recordPerPage" <~~ json
        supportPaging = "supportPaging" <~~ json
        symbolCompleteName = "symbolCompleteName" <~~ json
        symbolDetailsList = "symbolDetailsList" <~~ json
        symbolShortName = "symbolShortName" <~~ json
        timeFrameType = "timeFrameType" <~~ json
        totalPages = "totalPages" <~~ json
    }


    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "indexCode" ~~> indexCode,
            "pageNumber" ~~> pageNumber,
            "recordPerPage" ~~> recordPerPage,
            "supportPaging" ~~> supportPaging,
            "symbolCompleteName" ~~> symbolCompleteName,
            "symbolDetailsList" ~~> symbolDetailsList,
            "symbolShortName" ~~> symbolShortName,
            "timeFrameType" ~~> timeFrameType,
            "totalPages" ~~> totalPages,
            ])
    }
    
}