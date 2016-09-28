//
//  BourseNewsRequest.swift
//  SabadBan
//
//  Created by PC22 on 9/26/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation

public struct BourseNewsRequest {
    public let take : Int!
    public let api_token : String!
    public let page : Int!

    func getDic() -> [String : AnyObject] {
        let dic = [
        "take" : self.take,
        "api_token" : self.api_token,
        "page" : self.page
        ]
        return dic as! [String : AnyObject]
    }
}
