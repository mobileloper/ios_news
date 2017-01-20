//
//  UserDefaultsUtility.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 17/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class UserDefaultsUtility: NSObject {
    //MARK: - Feed Timestamp and StartupIndex
    class func setFeedsTimeStamp(timestamp: String?) {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        userDefaultObj.setValue(timestamp, forKey: "feedTimeStamp")
    }
    class func getFeedsTimeStamp()->String? {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        if let name = userDefaultObj.stringForKey("feedTimeStamp"){
            return name
        }else{
            return nil
        }
    }
    class func setFeedsSelectionScreen(timestamp: Int?) {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        userDefaultObj.setValue(timestamp!, forKey:"feedStartScreen")
    }
    class func getFeedsSelectionScreen()->Int? {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        if let name: AnyObject = userDefaultObj.valueForKey("feedStartScreen"){
            return name as? Int
        }else{
            return 0
        }
    }
    
    //MARK: - Device Token and Notication Status
   class func setDeviceToken(timestamp: String?) {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        userDefaultObj.setValue(timestamp, forKey: "deviceToken")
    }
   class func getDeviceToken()->String? {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        if let name = userDefaultObj.stringForKey("deviceToken"){
            return name
        }else{
            return ""
        }
    }
    class func setNotificationStatus(flag : String?) {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        userDefaultObj.setValue(flag!, forKey: "notificatioStatus")
    }
    class func getNotificationStatus()->String? {
        let userDefaultObj = NSUserDefaults.standardUserDefaults()
        if let name = userDefaultObj.stringForKey("notificatioStatus"){
            return name
        }else{
            return "1"
        }
    }
}
