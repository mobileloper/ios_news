//
//  CoreData.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 30/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import CoreData

class CoreData: NSObject {
    //MARK: - Saving/Updating Data Feeds
    class func saveAllFeedsLocally(array : JSON ){
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext  = appDelegate.managedObjectContext
        NSLog("test 111")
//         var err : NSError?
        for (_, subJson) in  array {
            CoreData.saveFeed(subJson, context: managedContext!)
        }
        NSLog("test 222")
        try! managedContext?.save()
        NSLog("test 333")
        CommonFunctions.getDocumentPath()
    }
    class func saveFeed(subJson : JSON , context : NSManagedObjectContext ){
       
        var entity : FeedClass
        NSLog("test 11")
        if  let _ = CoreData.fetchFeedWithId(subJson["id"].int32Value) { // if not present in db thn create new one
            entity = CoreData.fetchFeedWithId(subJson["id"].int32Value)!
            entity.isNew = false
        }else{
            entity  = NSEntityDescription.insertNewObjectForEntityForName("Feed", inManagedObjectContext: context) as! FeedClass
            entity.isNew = true
            entity.isFavoriteNew = false
        }
        NSLog("test 22")
        // values assign according to data
       
        entity.feed_Id = subJson["id"].int32Value
        entity.socialMediaType = subJson["social_media_type"].stringValue
        entity.videoFeed = CommonFunctions.checkStringForNull(subJson["video"].string)
        entity.createdTime = CommonFunctions.checkStringForNull(subJson["created_time"].string)
        entity.inTime = CommonFunctions.checkStringForNull(subJson["in_time"].string)
        entity.linkFeed = CommonFunctions.checkStringForNull(subJson["link"].string)
        entity.sourceType = CommonFunctions.checkStringForNull(subJson["source_type"].string)
        entity.socialFeed_Id = CommonFunctions.checkStringForNull(subJson["feed_id"].string)
        entity.feedType = CommonFunctions.checkStringForNull(subJson["feed_type"].string)
        var title = CommonFunctions.checkStringForNull(subJson["title"].string)
        print(subJson)
        let socialTypeObj  =  SocialType(rawValue:entity.socialMediaType)
        let feedType = FeedType(rawValue: entity.feedType)!
        if CommonFunctions.checkStringForNull(subJson["title"].string).isEmpty{
            title = CommonFunctions.getTitleFromFeed(feedType , socialType: socialTypeObj!, source: nil)
        }
        entity.titleFeed = title
//        entity.titleFeed = CommonFunctions.checkStringForNull(subJson["title"].string)
        entity.imageFeed = CommonFunctions.checkStringForNull(subJson["image"].string)
        entity.updatedTime = CommonFunctions.checkStringForNull(subJson["updated_time"].string)
    }
    
    class func updateFavoriteOfFeed(feed : FeedClass){
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext  = appDelegate.managedObjectContext
        
        feed.isFavorite = !feed.isFavorite
        if(feed.isFavorite){
            feed.isFavoriteNew = true
        }
        do{
            try managedContext?.save()
        }
        catch{
            
        }
    }
    class func updateNewOfFeed(feed : FeedClass){
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext  = appDelegate.managedObjectContext
//        var err : NSError?
        feed.isNew = !feed.isNew
        do{
            try managedContext?.save()
        }
        catch{
            
        }
    }
    
    class func updateNewFavoriteOfFeed(feed : FeedClass){
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext  = appDelegate.managedObjectContext
        //        var err : NSError?
        feed.isFavoriteNew = false
        do{
            try managedContext?.save()
        }
        catch{
            
        }
    }

    
    //MARK: - Fetching Data Feeds
    class func fetchFeedWithId(feedID : Int32)-> FeedClass?{
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Feed")
//        var error: NSError?
        
        let predicate = NSPredicate(format:"feed_Id == %i",feedID)
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        
        let fetchedResult = try! managedContext.executeFetchRequest(fetchRequest) as? [FeedClass]
        if let _ = fetchedResult {
            if fetchedResult!.count > 0{
                return fetchedResult![0]
            }else{
                return nil
            }
        }else{
//            print("Could not fetch \(error), \(error!.userInfo)")
            return nil
        }
    }
    class func fetchAllFeeds() -> [FeedClass]?{
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        
        let fetchedResult = try! managedContext.executeFetchRequest(fetchRequest) as? [FeedClass]
        
        if let _ = fetchedResult {
            return fetchedResult
        }else{
            return nil
        }
    }
    
    class func fetchTopMostFeedWithType(type : SocialType) -> (Int32 , String)?{
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Feed")

        
        let indexSort = NSSortDescriptor(key:"feed_Id", ascending:false)
        let sortArray = [indexSort]
        fetchRequest.sortDescriptors = sortArray
        
        if type != SocialType.All{
        fetchRequest.predicate = NSPredicate(format:"socialMediaType == %@", type.rawValue)
        }
        
        let fetchedResult : [FeedClass]? = try! managedContext.executeFetchRequest(fetchRequest) as? [FeedClass]
        if let _ = fetchedResult {
            if fetchedResult!.count > 0 {
                let feedObj = fetchedResult![0] as FeedClass
                return (feedObj.feed_Id , feedObj.inTime)
            }else{
                return nil
            }
        }else{
            
            return nil
        }
    }
    class func fetchBottomMostFeedWithType(type : SocialType) -> (String)?{
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        
        let indexSort = NSSortDescriptor(key:"inTime", ascending:true)
        let sortArray = [indexSort]
        fetchRequest.sortDescriptors = sortArray
        if type != SocialType.All{
        fetchRequest.predicate = NSPredicate(format:"socialMediaType == %@", type.rawValue)
        }
        
        let fetchedResult = try! managedContext.executeFetchRequest(fetchRequest) as? [FeedClass]
        if let _ = fetchedResult {
            if fetchedResult?.count > 0{
            let feedObj = fetchedResult![0] as FeedClass
            return (feedObj.inTime)
            }else{
                return nil
            }
        }else{
          
            return nil
        }
    }
    class func countOfSocialType(type : SocialType) -> Int{
        let appDelegate = CommonFunctions.getAppdelegateObject()
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        
        
        switch type{
        case .All:
             fetchRequest.predicate = NSPredicate(format:"isNew == true")
        case .Favorite:
             fetchRequest.predicate = NSPredicate(format:"isFavoriteNew == true")
        default:
             fetchRequest.predicate = NSPredicate(format:"socialMediaType == %@ AND isNew == true", type.rawValue)
        }
        
        let fetchedResult = try! managedContext.executeFetchRequest(fetchRequest) as? [FeedClass]
        if let _ = fetchedResult {
            return fetchedResult!.count
        }else{
            return 0
        }
    }
    
    class func nextAvailableKey(idKey : String , entityName : String , context : NSManagedObjectContext) -> Int{
        let fetchRequest = NSFetchRequest(entityName: entityName)
        _ = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        fetchRequest.returnsDistinctResults = true
        fetchRequest.resultType = NSFetchRequestResultType.DictionaryResultType
        
        let propertiesArray = [idKey]
        fetchRequest.propertiesToFetch = propertiesArray
        
        let indexSort = NSSortDescriptor(key: idKey, ascending:true)
        let sortArray = [indexSort]
        fetchRequest.sortDescriptors = sortArray
        let fetchedResult = try! context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        
        let lastObject =  fetchedResult.last
        
        if let _ = lastObject{
            let myindex  = lastObject!.valueForKey(idKey)!.integerValue + 1
            return myindex
        }else{
            return 1
        }
    }
}
