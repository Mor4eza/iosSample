//
//	Response.swift
//
//	Create by Morteza Gharedaghi on 10/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation 
import Gloss

//MARK: - Response
public struct BourseNewsResponse: Glossy {

	public let count : Int!
	public let newsDetailsList : [BourseNewsDetailsList]!



	//MARK: Decodable
	public init?(json: JSON){
		count = "count" <~~ json
		newsDetailsList = "newsDetailsList" <~~ json
	}


	//MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"count" ~~> count,
		"newsDetailsList" ~~> newsDetailsList,
		])
	}

}