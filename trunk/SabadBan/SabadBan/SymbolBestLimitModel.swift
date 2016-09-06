//
//	SymbolBestLimitModel.swift
//
//	Create by Morteza Gharedaghi on 6/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation 
import Gloss

//MARK: - SymbolBestLimitModel
public struct SymbolBestLimitModel: Glossy {

	public let errorCode : AnyObject!
	public let errorDescription : AnyObject!
	public let response : SymbolBestLimitResponse!
	public let successful : Bool!



	//MARK: Decodable
	public init?(json: JSON){
		errorCode = "errorCode" <~~ json
		errorDescription = "errorDescription" <~~ json
		response = "response" <~~ json
		successful = "successful" <~~ json
	}


	//MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"errorCode" ~~> errorCode,
		"errorDescription" ~~> errorDescription,
		"response" ~~> response,
		"successful" ~~> successful,
		])
	}

}