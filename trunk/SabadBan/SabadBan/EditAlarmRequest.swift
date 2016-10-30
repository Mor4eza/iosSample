//
//  EditAlarmRequest.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/29/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct EditAlarmRequest {
    let id: Int!
    let email: String!
    let symbolCode: String!
    let atPrice: Double!
    let orderType: String!
    let alarmPrice: Double!
    let description: String!
    let active = Bool()

    func getDic() -> [String: String] {
        let dic = [
                "id": id,
                "email": email,
                "symbolCode": symbolCode,
                "atPrice": atPrice,
                "orderType": orderType,
                "alarmPrice": alarmPrice,
                "description": description,
                "active": active]

        return dic as! [String: String]
    }
}
