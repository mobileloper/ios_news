//
//  FeedClass.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 07/08/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import Foundation
import CoreData

class FeedClass: NSManagedObject {

    @NSManaged var createdTime: String
    @NSManaged var feed_Id: Int32
    @NSManaged var feedType: String
    @NSManaged var imageFeed: String
    @NSManaged var inTime: String
    @NSManaged var isFavorite: Bool
    @NSManaged var linkFeed: String
    @NSManaged var socialFeed_Id: String
    @NSManaged var socialMediaType: String
    @NSManaged var sourceType: String
    @NSManaged var titleFeed: String
    @NSManaged var updatedTime: String
    @NSManaged var videoFeed: String
    @NSManaged var isNew: Bool
    @NSManaged var isFavoriteNew: Bool
}
