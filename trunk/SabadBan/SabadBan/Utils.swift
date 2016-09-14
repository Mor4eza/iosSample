//
//  Utils.swift
//  HamrahTraderPro
//
//  Created by Morteza Gharedaghi on 8/17/16.
//  Copyright © 2016 SefrYek. All rights reserved.
//

import Foundation
import Localize_Swift

var IOS_VERSION = CFloat(UIDevice.currentDevice().systemVersion)!
public func getAppLanguage() -> String {
    return Localize.currentLanguage()
}

var isSimulator: Bool {
    return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
}

public class Utils {
    
  
}
