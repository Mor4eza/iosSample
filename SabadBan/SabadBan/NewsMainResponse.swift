//
//  NewsMainResponse.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
import Gloss

public struct NewsMainResponse<T: Glossy> : Glossy {
    public let errorCode : AnyObject!
    public let errorDescription : AnyObject!
    public let response : T!
    public let success : Bool?
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        errorCode = "errorCode" <~~ json
        errorDescription = "errorDescription" <~~ json
        response = "response" <~~ json
        success = "success" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "errorCode" ~~> errorCode,
            "errorDescription" ~~> errorDescription,
            "response" ~~> response,
            "success" ~~> success
            ])
    }
}