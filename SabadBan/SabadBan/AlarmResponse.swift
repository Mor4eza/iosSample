
//	AlarmResponse.swift
//
//	Create by Morteza Gharedaghi on 29/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - AlarmResponse
public struct AlarmResponse: Glossy {
    
    public let alarmFilterList : [AlarmFilterList]!
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        alarmFilterList = "alarmFilterList" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "alarmFilterList" ~~> alarmFilterList,
            ])
    }
    
}