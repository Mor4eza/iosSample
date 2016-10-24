//
//  LogoutRequest.swift
//  SabadBan
//
//  Created by PC22 on 10/24/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct LogoutRequest {
    let apiToken : String!
    
    func getDic() -> [String : AnyObject] {
        let dic : [String : AnyObject] = [
            "apiToken": apiToken
        ]
        return dic
    }
}