//
//  SymbolListAndDetailsRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/27/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct SymbolListAndDetailsRequest {
    let pageNumber: Int!
    let recordPerPage: Int!
    let symbolCode: [Int64]!
    let supportPaging: Bool!
    let language: String!

    func getDic() -> [String: AnyObject] {

        var sCodes = [String]()
        for symbol in symbolCode {
            sCodes.append(String(symbol))
        }

        let dic = [
                "pageNumber": pageNumber,
                "recordPerPage": recordPerPage,
                "symbolCode": sCodes,
                "supportPaging": supportPaging,
                "language": language
        ]
        return dic as! [String: AnyObject]
    }
}
