//
//  FindAlarmsRequest.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

struct FindAlarmsRequest {
    let email: String!
    let symbolCode: Int64!

    func getDic() -> [String: AnyObject] {
        let dic : [String: AnyObject]  = [
                "email": email,
                "symbolCode": String(symbolCode)]

        return dic
    }
}
