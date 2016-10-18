//
//  AcralizerClient.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 10/18/16.
//  Copyright © 2016 Sefr Yek. All rights reserved.
//

import UIKit
import Alamofire

var AcralizerUrl:String!
var AcralizerUsername:String!
var AcralizerPassword:String!
class AcralizerClient  {
    
    init(url:String, username:String, password:String) {
        AcralizerUsername = username
        AcralizerPassword = password
        AcralizerUrl = url

    }


    func start(){

        NSSetUncaughtExceptionHandler { exception in

            let source:String = exception.callStackSymbols[4]
            let separatorSet:NSCharacterSet = NSCharacterSet(charactersInString: " -[]+?,")
            var array:[String] = source.componentsSeparatedByCharactersInSet(separatorSet)
            for i in exception.callStackSymbols {

                print("\n \n Stack: \(i)")
            }
            array = array.filter({ $0 != "" })
            let exceptionStr:String = array[3];
            let exceptionArr = exceptionStr.split("\\d+")
            let fileName = exceptionArr[2]
            let methodName = exceptionArr[3]


            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                /**
                 Acralizer
                 POST http://acra.sefryek.com:5984/acra-p343-sabadban-ios/_design/acra-storage/_update/report
                 */

                // Add Headers
                let plainString = "\(AcralizerUsername):\(AcralizerPassword)" as NSString
                let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
                let base64String = plainData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))


                let headers = [
                    "Content-Type":"application/json; charset=utf-8",
                    "Authorization":"Basic \(base64String!)",
                ]

                let uuid = NSUUID().UUIDString

                // JSON Body
                let body : [String : AnyObject]
                let date = NSDate()
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
                formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
                formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
                print(formatter.stringFromDate(date))

                body = [
                    "USER_APP_START_DATE": "2016-10-17T15:24:37.181+03:30",
                    "STACK_TRACE": "\(exception.callStackSymbols)",
                    "REPORT_ID": "\(uuid)",
                    "USER_CRASH_DATE": formatter.stringFromDate(date),
                    "APP_VERSION_CODE":appVersionCode!,
                    "PACKAGE_NAME": appPackageName!,
                    "ANDROID_VERSION": UIDevice.currentDevice().systemVersion,
                    "FILE_PATH": "",
                    "PRODUCT": UIDevice.currentDevice().name,
                    "PHONE_MODEL": UIDevice.currentDevice().localizedModel,
                    "APP_VERSION_NAME": appVersionName!,
                    "CUSTOM_DATA": [
                        "METHOD": methodName,
                        "CLASS_NAME": fileName
                    ],
                    "INSTALLATION_ID": "8961e5ec-e43b-4e11-1b49-d3f6cf222a9d",
                    "LOGCAT": "\(exception)",
                    "BRAND": "APPLE"
                ]
                print("Body\(body)")

                // Fetch Request
                Alamofire.request(.POST, AcralizerUrl, headers: headers, parameters: body as [String : AnyObject], encoding: .JSON)
                    .responseJSON { response in
                        if (response.result.error == nil) {
                            debugPrint("HTTP Response Body: \(response.data)")
                        }
                        else {
                            debugPrint("HTTP Request failed: \(response.result.error)")
                        }



                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = (storyBoard.instantiateViewControllerWithIdentifier("baseNavigationController") as! UINavigationController)
                        //set storyboard ID to your root navigationController.
                        let vc = storyBoard.instantiateViewControllerWithIdentifier("loginViewController")
                        // //set storyboard ID to viewController.
                        controller.setViewControllers([vc], animated: true)
                        let appDelegate = (UIApplication.sharedApplication().delegate! as! AppDelegate)
                        appDelegate.window!.rootViewController! = controller


//                        exit(0)
                }
            })
            
            NSRunLoop.currentRunLoop().run()
            
            print("ENDDDDDdDD")
        }
        
    }

}

extension String {

    // java, javascript, PHP use 'split' name, why not in Swift? :)
    func split(regex: String) -> Array<String> {
        do{
            let regEx = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions())
            let stop = "<SomeStringThatYouDoNotExpectToOccurInSelf>"
            let modifiedString = regEx.stringByReplacingMatchesInString (self, options: NSMatchingOptions(), range: NSMakeRange(0, characters.count), withTemplate:stop)
            return modifiedString.componentsSeparatedByString(stop)
        } catch {
            return []
        }
    }
}