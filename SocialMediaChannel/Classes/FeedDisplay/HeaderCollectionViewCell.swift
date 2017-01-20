//
//  HeaderCollectionViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 21/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import Kingfisher

class HeaderCollectionViewCell: UICollectionViewCell {
    //MARK: - Action Buttons
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var shareImage: UIButton!
    @IBOutlet weak var playBtn: UIButton!
   
    
    //MARK: - Varibles
    @IBOutlet weak var newFlag: UIImageView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var headingText: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        newFlag.image = UIImage(named:NSLocalizedString("ic-tag-new", comment: ""))
        // Initialization code
    }    
    func setUpCell(index : NSInteger , feedObject : FeedClass){
        favoriteBtn.tag = index
        playBtn.tag = index
        shareImage.tag = index
        
        favoriteBtn.selected = feedObject.isFavorite
        newFlag.hidden = !feedObject.isNew
        
        if feedObject.isNew{ // new will show only once
           // CoreData.updateNewOfFeed(feedObject)
        }
        
        headingText.text = feedObject.titleFeed
        timeText.text = CommonFunctions.formattedString(feedObject.createdTime)
        feedImage.kf_setImageWithURL(NSURL(string:CommonFunctions.getImageNameFromCollection(feedObject.imageFeed, thumbnail: true))! , placeholderImage: UIImage(named:"feedDefault"))
    }
}
