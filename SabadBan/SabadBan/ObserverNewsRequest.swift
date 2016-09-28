//
//  ObserverNewsRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct ObserverNewsRequest {

    let newsStartTime : String!
    let symbolCodeList : [String]!

    func getDic() -> [String : AnyObject] {
        let dic = [
            "newsStartTime": newsStartTime,
            "symbolCodeList": symbolCodeList
        ]
        return dic as! [String : AnyObject]
    }
}
