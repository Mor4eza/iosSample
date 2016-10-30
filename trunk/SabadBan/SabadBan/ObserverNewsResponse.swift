//
//	ObserverNewsResponse.swift
//
//	Create by Morteza Gharedaghi on 7/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - ObserverNewsResponse

public struct ObserverNewsResponse: Glossy {

    public let newsDetailsList: [NewsDetailsList]!
    public let pageNumber: Int!
    public let recordPerPage: Int!
    public let supportPaging: Bool!
    public let totalPages: Int!

    //MARK: Decodable
    public init?(json: JSON) {
        newsDetailsList = "newsDetailsList" <~~ json
        pageNumber = "pageNumber" <~~ json
        recordPerPage = "recordPerPage" <~~ json
        supportPaging = "supportPaging" <~~ json
        totalPages = "totalPages" <~~ json
    }

    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "newsDetailsList" ~~> newsDetailsList,
                "pageNumber" ~~> pageNumber,
                "recordPerPage" ~~> recordPerPage,
                "supportPaging" ~~> supportPaging,
                "totalPages" ~~> totalPages,
        ])
    }

}
