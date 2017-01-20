//
//  MainTextFeedTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 24/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class MainTextFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var newFlag: UIImageView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var backText: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleText.textContainerInset = UIEdgeInsetsZero;
        titleText.textContainer.lineFragmentPadding = 0;
        newFlag.image = UIImage(named:NSLocalizedString("ic-tag-new", comment: ""))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Setup Cell
    func setUpCell(index : NSInteger , feedObject : FeedClass){
        shareBtn.tag = index
        favoriteBtn.tag = index
        favoriteBtn.selected = feedObject.isFavorite
        
        let socialTypeObj  =  SocialType(rawValue:feedObject.socialMediaType)
        mainImage.image = socialTypeObj?.flagImage()
//        titleText.textColor = socialTypeObj?.color()
        newFlag.hidden = !feedObject.isNew
        
        if feedObject.isNew{ // new will show only once
          //  CoreData.updateNewOfFeed(feedObject)
        }
        
        var titleString = feedObject.titleFeed
        let feedType = FeedType(rawValue: feedObject.feedType)!
        if titleString.isEmpty{
            titleString = NSLocalizedString(CommonFunctions.getTitleFromFeed(feedType , socialType: socialTypeObj!, source: nil), comment: "")
        }
        
//        backText.text = titleString
        CommonFunctions.textViewLineHeight(titleString, titleField: titleText, color : socialTypeObj!.color())
        timeText.text = CommonFunctions.formattedString(feedObject.createdTime)
    }

}
