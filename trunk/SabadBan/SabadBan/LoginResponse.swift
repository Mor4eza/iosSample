//
//	LoginResponse.swift
//
//	Create by Morteza Gharedaghi on 11/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - LoginResponse
public struct LoginResponse: Glossy {
    
    public let apiToken : String?
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        apiToken = "api_token" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "api_token" ~~> apiToken,
            ])
    }
    
}