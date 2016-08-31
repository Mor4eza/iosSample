//
//	Response.swift
//
//	Create by Morteza Gharedaghi on 28/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation 
import Gloss

//MARK: - Response
public struct Response: Glossy {

	public let indexDetailsList : [IndexDetailsList]!
	public let timeFrameType : String!



	//MARK: Decodable
	public init?(json: JSON){
		indexDetailsList = "indexDetailsList" <~~ json
		timeFrameType = "timeFrameType" <~~ json
	}


	//MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"indexDetailsList" ~~> indexDetailsList,
		"timeFrameType" ~~> timeFrameType,
		])
	}

}