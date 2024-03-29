//
//  AppDelegate.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import Localize_Swift
import Firebase
import FirebaseMessaging
import Alamofire
import GSMessages
import BRYXBanner
import Gloss

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UITextField.appearance().keyboardAppearance = .Dark
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.valueForKey("DefaultLanguage") == nil {
            defaults.setValue(Language.fa.rawValue, forKey: "DefaultLanguage")
            Localize.setCurrentLanguage(defaults.stringForKey("DefaultLanguage")!)
        }
        debugPrint(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as? String)
        
        //Navigation Color
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = AppBarTintColor
        navigationBarAppearace.barTintColor = AppBarTintColor
        
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        navigationBarAppearace.barStyle = UIBarStyle.Black
        navigationBarAppearace.tintColor = UIColor.whiteColor()
        
        //FCM
        FIRApp.configure()
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
        //AcraLizer
        //        #if !Dev
        //            let acra = AcralizerClient(url: AcraUrl, username: "p343-sabadban-ios", password: "p343-sabadban-ios@!#^")
        //            acra.start()
        //        #endif
        
        return true
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Apple Push Notification -->APN
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Sandbox)
        FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Prod)
        
        if FIRInstanceID.instanceID().token() != nil {
            PushToken = FIRInstanceID.instanceID().token()!
        } else {
            PushToken = Strings.EmptyToken
        }
        print("REAL_TOKEN: \(PushToken)")
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0 ..< deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        //        print("tokenString: \(tokenString)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error)
    }
    
    func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        if let userInfo = launchOptions?.valueForKeyPath("UIApplicationLaunchOptionsRemoteNotificationKey") {
            handlePushNotification(userInfo as! [NSObject : AnyObject])
        }
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
        handlePushNotification(userInfo)
    }
    
    func handlePushNotification(userInfo: [NSObject: AnyObject]) {
        
        var alarmData: PushNotificationAlarmData?
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let body = alert["body"] as? String {
                    let title = alert["title"] as? String
                    
                    if var dataString = userInfo["data"] as? String {
                        // alarm banner
                        
                        dataString = dataString.stringByReplacingOccurrencesOfString("'", withString: "\"")
                        let nsData = dataString.dataUsingEncoding(NSUTF8StringEncoding)!
                        
                        let jsonData = try! NSJSONSerialization.JSONObjectWithData(nsData, options: NSJSONReadingOptions(rawValue: 0))
                        
                        if let parsedAlarmData = PushNotificationAlarmData(json: jsonData as! JSON) {
                            alarmData = parsedAlarmData
                            let banner = Banner(title: title ,
                                                subtitle: body ,
                                                image: UIImage(named: "AppIcon"),
                                                backgroundColor: UIColor.redColor(),
                                                didTapBlock: {self.openSymbolDetailsVC(parsedAlarmData.symbolCode, symbolName: parsedAlarmData.symbolShortNameFa)})
                            
                            banner.show(duration: 5.0)
                        }
                        
                        
                    } else {
                        // news banner
                        
                        let banner = Banner(title: title ,
                                            subtitle: body ,
                                            image: UIImage(named: "AppIcon"),
                                            backgroundColor: UIColor.redColor(),
                                            didTapBlock: {self.openNewsVC()})
                        
                        banner.show(duration: 5.0)
                    }
                    
                    
                }
            }
        }
        //        print("GCM_TOKEN: \(PushToken)")
        
        
        print(userInfo)
        
        if (UIApplication.sharedApplication().applicationState == .Inactive || UIApplication.sharedApplication().applicationState == .Background) {
            if alarmData != nil {
                openSymbolDetailsVC((alarmData!.symbolCode)!, symbolName: (alarmData?.symbolShortNameFa)!)
            } else {
                openNewsVC()
            }
            
        }
    }
    
    func openSymbolDetailsVC(symbolCode: Int64, symbolName: String) {
        UIView.transitionWithView(self.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {

            SelectedSymbolCode = symbolCode
            SelectedSymbolName = symbolName
            
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: UIConstants.Main, bundle: nil)
            let newsVC = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.symbolDetailsTabBar) as! SymbolDetailsTabBar
            newsVC.hasComeFromPush = true
            let myNav = MyNavigationController(menuViewController: MyMenuTableViewController(), contentViewController: newsVC)
            
            appdelegate.window!.rootViewController = myNav
            }, completion: nil)
    }
    
    func openNewsVC() {
        
        UIView.transitionWithView(self.window!, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, animations: {
            
            let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: UIConstants.Main, bundle: nil)
            let newsVC = mainStoryboard.instantiateViewControllerWithIdentifier(UIConstants.NewsTabBarController) as! NewsTabBarController
            let myNav = MyNavigationController(menuViewController: MyMenuTableViewController(), contentViewController: newsVC)
            //                myNav.viewDidLoad()
            appdelegate.window!.rootViewController = myNav
            
            }, completion: nil)
        
        
    }
}
