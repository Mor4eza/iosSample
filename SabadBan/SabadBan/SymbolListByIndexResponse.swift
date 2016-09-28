//
//	Response.swift
//
//	Create by Morteza Gharedaghi on 29/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - Response
public struct SymbolListByIndexResponse: Glossy {

	public let indexCode : String!
	public let indexNameEn : AnyObject!
	public let indexNameFa : AnyObject!
	public let pageNumber : Int!
	public let recordPerPage : Int!
	public let supportPaging : Bool!
	public let symbolDetailsList : [SymbolDetailsList]!
	public let timeFrameType : String!
	public let totalPages : Int!

	//MARK: Decodable
	public init?(json: JSON){
		indexCode = "indexCode" <~~ json
		indexNameEn = "indexNameEn" <~~ json
		indexNameFa = "indexNameFa" <~~ json
		pageNumber = "pageNumber" <~~ json
		recordPerPage = "recordPerPage" <~~ json
		supportPaging = "supportPaging" <~~ json
		symbolDetailsList = "symbolDetailsList" <~~ json
		timeFrameType = "timeFrameType" <~~ json
		totalPages = "totalPages" <~~ json
	}

	//MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"indexCode" ~~> indexCode,
		"indexNameEn" ~~> indexNameEn,
		"indexNameFa" ~~> indexNameFa,
		"pageNumber" ~~> pageNumber,
		"recordPerPage" ~~> recordPerPage,
		"supportPaging" ~~> supportPaging,
		"symbolDetailsList" ~~> symbolDetailsList,
		"timeFrameType" ~~> timeFrameType,
		"totalPages" ~~> totalPages,
		])
	}

}
