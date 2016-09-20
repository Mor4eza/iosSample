//
//  RegisterErrorModel.swift
//  SabadBan
//
//  Created by ehsan on 9/20/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
import Gloss

//MARK: - Error
public struct RegisterErrorModel: Glossy {
    
    public let email : [String]!
    public let unigueEmail : Bool!
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        email = "email" <~~ json
        unigueEmail = "unigueEmail" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "email" ~~> email,
            "unigueEmail" ~~> unigueEmail,
            ])
    }
    
}