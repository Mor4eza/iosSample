//
//  MainResponse.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/6/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
import Gloss

//MARK: - Indexs
public struct MainResponse<T:Glossy>: Glossy {
    
    public let errorCode : AnyObject!
    public let errorDescription : AnyObject!
    public let response : T!
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