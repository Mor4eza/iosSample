//
//  ForgetPasswordRequest.swift
//  SabadBan
//
//  Created by PC22 on 10/22/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct ForgetPasswordRequest {
    let email: String!
    
    func getDic() -> [String : AnyObject] {
        let dic : [String : AnyObject]
        
        dic = [
            "email": email
        ]
        return dic
    }
}
