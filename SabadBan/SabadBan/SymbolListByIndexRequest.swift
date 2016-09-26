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
    let symbolCode : [String]!
    let supportPaging : Bool!
    
    func getDic() -> [String : AnyObject] {
        let dic = [
            "pageNumber": pageNumber,
            "recordPerPage": recordPerPage,
            "symbolCode": symbolCode,
            "supportPaging": supportPaging
        ]
        return dic as! [String : AnyObject]
    }
}
