//
//	ForgetPasswordResult.swift
//
//	Create by PC22 on 22/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - Result
public struct ForgetPasswordResult: Glossy {
    
    public let mail : Int!
    
    
    
    //MARK: Decodable
    public init?(json: JSON){
        mail = "mail" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "mail" ~~> mail,
            ])
    }
    
}