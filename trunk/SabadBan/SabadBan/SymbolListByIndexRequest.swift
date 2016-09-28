//
//  SymbolListByIndexRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct SymbolListByIndexRequest {
    let pageNumber : Int!
    let recordPerPage : Int!
    let indexCode : String!
    let supportPaging : Bool!
    let timeFrameType : Int!

    func getDic() -> [String : AnyObject] {
        let dic = [
            "pageNumber": pageNumber,
            "recordPerPage": recordPerPage,
            "indexCode": indexCode,
            "supportPaging": supportPaging,
            "timeFrameType": timeFrameType
        ]
        return dic as! [String : AnyObject]
    }
}
