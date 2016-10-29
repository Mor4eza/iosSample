//
//  DeleteAlarmRequest.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
public struct DeleteAlarmRequest {
    let id : Int!
    let email : String!

    func getDic() -> [String : String] {
        let dic = [
            "id": id,
            "email":email]

        return dic as! [String : String]
    }
}
