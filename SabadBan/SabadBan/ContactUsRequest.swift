//
//  ContactUsRequest.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/1/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct ContactUsRequest {
    let name: String!
    let email: String!
    let subject: String!
    let message: String!

    func getDic() -> [String: String] {
        let dic = [
                "name": name,
                "email": email,
                "subject": subject,
                "message": message]

        return dic as! [String: String]
    }
}
