//
//	ForgetPasswordResponse.swift
//
//	Create by PC22 on 22/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

//MARK: - RootClass

public struct ForgetPasswordResponse: Glossy {

    public let error: String!
    public let errorCode: Int!
    public let message: String!
    public let result: ForgetPasswordResult!
    public let success: Bool!


    //MARK: Decodable
    public init?(json: JSON) {
        error = "error" <~~ json
        errorCode = "error_code" <~~ json
        message = "message" <~~ json
        result = "result" <~~ json
        success = "success" <~~ json
    }


    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
                "error" ~~> error,
                "error_code" ~~> errorCode,
                "message" ~~> message,
                "result" ~~> result,
                "success" ~~> success,
        ])
    }

}