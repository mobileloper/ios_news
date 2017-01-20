//
//  AppDelegate.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 16/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import CoreData
@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let frame = UIScreen.mainScreen().bounds
        window = UIWindow(frame: frame)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        setUpWindow()
        registerForPushNotifications()
        CommonFunctions.checkForSquiteDatabase()
        // Override point for customization after application launch.
        return true
    }
    
    func setUpWindow(){
        let itemsViewControler : CommonViewController = self.getStartUpRootFromIndex()
        let naviViewController : CommonNavigationViewController = CommonNavigationViewController(navigationBarClass: UINavigationBar().classForCoder, toolbarClass:nil)
        naviViewController.setViewControllers([itemsViewControler], animated: false)
        if let window = self.window{
            window.rootViewController = naviViewController
            window.makeKeyAndVisible()
        }
    }
    
    func getStartUpRootFromIndex()->CommonViewController{
        let index : QuickLaunchType = QuickLaunchType(rawValue: UserDefaultsUtility.getFeedsSelectionScreen()!)!
        
        switch index {
        case QuickLaunchType.Youtube:
            let newVC : SocialFeedsViewController = SocialFeedsViewController(nibName:"SocialFeedsViewController", bundle: nil)
            return newVC
        case QuickLaunchType.AllFeeds, QuickLaunchType.Favorite:
            let newVC : FeedsViewController = FeedsViewController(nibName:"FeedsViewController", bundle: nil)
            return newVC
        default:
            var social : SocialType
            switch index as QuickLaunchType{
            case QuickLaunchType.Facebook:
                social = SocialType.Facebook
            case QuickLaunchType.Twitter:
                social = SocialType.Twitter
            case QuickLaunchType.Instagram:
                social = SocialType.Instagram
            case QuickLaunchType.Blog:
                social = SocialType.Blog
            default:
                social = SocialType.Facebook
            }
            let newVC : OthereFeedsViewController = OthereFeedsViewController(nibName:"OthereFeedsViewController", bundle: nil)
            newVC.socialType = social
            return newVC
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        self.saveContext()
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    //MARK: - Push Notification Methods
    func registerForPushNotifications(){
        if CommonFunctions.getiOSVersion() >= 8 {
         let pushSettings: UIUserNotificationSettings  = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound] , categories:nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(pushSettings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
            
        }else{ //for below iOS 8
          //UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge | UIRemoteNotificationType.Alert | UIRemoteNotificationType.Sound )
        }
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>")
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        print("device Token \(deviceTokenString)")
        
        if UserDefaultsUtility.getDeviceToken() != deviceTokenString{
        self.updateNotificationFlagWithDeviceToken(deviceTokenString, flag: UserDefaultsUtility.getNotificationStatus()!)
        }
        
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
          print( error.localizedDescription )
    }
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
    }
    // MARK: - Core Data stack
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "finoit.SocialMediaChannel" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("SocialMediaChannel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SocialMediaChannel.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error1 as NSError {
                    error = error1
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error!.userInfo)")
                    abort()
                }
            }
        }
    }
    
    //MARK: - Update notification details Request
    func updateNotificationFlagWithDeviceToken(token : String , flag : String){
        var dictNotification = ["device_id": token , "noti_status": flag]
        var urlString = kUpdateNotificationStatus
        NetworkClass.responseWithUrl(urlString, parameter: dictNotification, requestType: RequestType.POST, tagString: "noticationUpdate") { (status, responseObj, error, statusCode, tag) in
            print(responseObj, terminator: "")
            if status {
                 UserDefaultsUtility.setDeviceToken(token)
                 UserDefaultsUtility.setNotificationStatus(flag)
            }
        
        }
    }
}

