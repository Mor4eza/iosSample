//
//  LoginRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct LoginRequest {
    let email: String!
    let device_token: String!
    let password: String!

    func getDic() -> [String: AnyObject] {
        let dic: [String: AnyObject]

        dic = [
                "email": email,
                "device_token": device_token,
                "password": password
        ]
        return dic
    }
}
