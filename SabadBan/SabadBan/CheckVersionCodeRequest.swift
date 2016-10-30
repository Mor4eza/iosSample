//
//  CheckVersionCodeRequest.swift
//  SabadBan
//
//  Created by PC22 on 10/23/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct CheckVersionCodeRequest {
    let osVersion: String!
    let osName: String!
    let versionCode: Double!

    func getDic() -> [String: AnyObject] {
        let dic: [String: AnyObject] = [
                "osVersion": osVersion,
                "osName": osName,
                "versionCode": versionCode
        ]
        return dic
    }
}
