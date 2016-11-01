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
    let symbolCode: CLong!

    func getDic() -> [String: AnyObject] {
        let dic = [
                "email": email,
                "symbolCode": symbolCode]

        return dic as! [String: AnyObject]
    }
}
