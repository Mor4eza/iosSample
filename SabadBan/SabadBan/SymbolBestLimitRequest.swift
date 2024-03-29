//
//  SymbolBestLimitRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct SymbolBestLimitRequest {
    let symbolCode: Int64!

    func getDic() -> [String: AnyObject] {
        let dic: [String: AnyObject]

        dic = [
                "symbolCode": String(symbolCode)
        ]
        return dic
    }
}
