//
//  SymbolNamesRequest.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/5/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct SymbolNamesRequest {
    let pageNumber : Int!
    let recordPerPage : Int!
    let symbolCode : [String]!
    let supportPaging : Bool!
    let language:String!

    func getDic() -> [String : AnyObject] {
        let dic = [
            "pageNumber": pageNumber,
            "recordPerPage": recordPerPage,
            "symbolCode": symbolCode,
            "supportPaging": supportPaging,
            "language": language
        ]
        return dic as! [String : AnyObject]
    }
}
