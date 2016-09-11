//
//  AppDelegate.swift
//  SabadBan
//
//  Created by Morteza Gharedaghi on 8/28/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import UIKit
import Localize_Swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if defaults.valueForKey("DefaultLanguage") == nil {
            defaults.setValue("fa", forKey: "DefaultLanguage")
             Localize.setCurrentLanguage(defaults.stringForKey("DefaultLanguage")!)
        }
        debugPrint(NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as? String)
        
        //Navigation Color
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = AppBarTintColor
        navigationBarAppearace.barTintColor = AppBarTintColor
        // change navigation item title color
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        navigationBarAppearace.barStyle = UIBarStyle.Black
        navigationBarAppearace.tintColor = UIColor.whiteColor()

        
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound]
        let pushNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        application.registerUserNotificationSettings(pushNotificationSettings)
        application.registerForRemoteNotifications()
        
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
        debugPrint("DEVICE TOKEN = \(deviceToken)")
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        debugPrint(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }
}

