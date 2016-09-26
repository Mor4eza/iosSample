//
//  IndexDetailsRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct IndexDetailsRequest {
    let timeFrameType : TimeFrameType!
    let indexCode : String!
    
    func getDic() -> [String : AnyObject] {
        let dic = [
            "timeFrameType": timeFrameType.rawValue,
            "indexCode":indexCode
        ]
        return dic as! [String : AnyObject]
    }
}

