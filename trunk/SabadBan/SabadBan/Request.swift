//
//  Request.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 9/25/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import Foundation
import Alamofire

import Gloss
import SwiftEventBus
class Request :BaseViewController{


    class func postData<T:Glossy>(urlString: String, body:[String: AnyObject]? = nil , completion: (T?, NSError?) -> Void) {

        Alamofire.request(.POST, urlString, headers: ServicesHeaders, parameters: body, encoding: .JSON)
            .validate(statusCode: 200..<300)
            .responseObjectErrorHadling(T.self) { response in
                guard response.result.isSuccess else{
                    if response.result.error?.code == -1009 {
                    SwiftEventBus.post(NetworkErrorAlert)
                    }else if (response.result.error?.code == -1001 ){
                    SwiftEventBus.post(TimeOutErrorAlert)
                    }
                    print("Error while fetching: \(response.result.error?.code)")
                    completion(nil, response.result.error)
                    return
                }
                if let responseObject = response.result.value{
                    completion(responseObject, nil)
                }
        }
    }

}
