//
//  FindAlarmsRequest.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
struct FindAlarmsRequest {
    let email : String!
    let symbolCode : Int!

    func getDic() -> [String : Int] {
        let dic = [
            "email":email,
            "message": symbolCode]

        return dic as! [String : Int]
    }
}
