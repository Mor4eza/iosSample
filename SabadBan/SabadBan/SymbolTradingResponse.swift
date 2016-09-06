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

//MARK: - SymbolTradingResponse
public struct SymbolTradingResponse: Glossy {

	public let buyNumberLegal : Float!
	public let buyNumberReal : Float!
	public let buyPercentLegal : Double!
	public let buyPercentReal : Double!
	public let buyVolumeLegal : Float!
	public let buyVolumeReal : Float!
	public let sellNumberLegal : Float!
	public let sellNumberReal : Float!
	public let sellPercentLegal : Double!
	public let sellPercentReal : Double!
	public let sellVolumeLegal : Float!
	public let sellVolumeReal : Float!
	public let symbolCode : String!
	public let symbolCompleteNameFa : String!
	public let symbolNameEn : String!
	public let symbolNameFa : String!



	//MARK: Decodable
	public init?(json: JSON){
		buyNumberLegal = "buyNumberLegal" <~~ json
		buyNumberReal = "buyNumberReal" <~~ json
		buyPercentLegal = "buyPercentLegal" <~~ json
		buyPercentReal = "buyPercentReal" <~~ json
		buyVolumeLegal = "buyVolumeLegal" <~~ json
		buyVolumeReal = "buyVolumeReal" <~~ json
		sellNumberLegal = "sellNumberLegal" <~~ json
		sellNumberReal = "sellNumberReal" <~~ json
		sellPercentLegal = "sellPercentLegal" <~~ json
		sellPercentReal = "sellPercentReal" <~~ json
		sellVolumeLegal = "sellVolumeLegal" <~~ json
		sellVolumeReal = "sellVolumeReal" <~~ json
		symbolCode = "symbolCode" <~~ json
		symbolCompleteNameFa = "symbolCompleteNameFa" <~~ json
		symbolNameEn = "symbolNameEn" <~~ json
		symbolNameFa = "symbolNameFa" <~~ json
	}


	//MARK: Encodable
	public func toJSON() -> JSON? {
		return jsonify([
		"buyNumberLegal" ~~> buyNumberLegal,
		"buyNumberReal" ~~> buyNumberReal,
		"buyPercentLegal" ~~> buyPercentLegal,
		"buyPercentReal" ~~> buyPercentReal,
		"buyVolumeLegal" ~~> buyVolumeLegal,
		"buyVolumeReal" ~~> buyVolumeReal,
		"sellNumberLegal" ~~> sellNumberLegal,
		"sellNumberReal" ~~> sellNumberReal,
		"sellPercentLegal" ~~> sellPercentLegal,
		"sellPercentReal" ~~> sellPercentReal,
		"sellVolumeLegal" ~~> sellVolumeLegal,
		"sellVolumeReal" ~~> sellVolumeReal,
		"symbolCode" ~~> symbolCode,
		"symbolCompleteNameFa" ~~> symbolCompleteNameFa,
		"symbolNameEn" ~~> symbolNameEn,
		"symbolNameFa" ~~> symbolNameFa,
		])
	}

}