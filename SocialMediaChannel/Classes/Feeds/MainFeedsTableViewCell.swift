//
//  MainFeedsTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 17/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import Kingfisher

class MainFeedsTableViewCell: UITableViewCell {
    //MARK: Outlets And Varibles
    @IBOutlet weak var feedMainImage: UIImageView!
    @IBOutlet weak var subtitleFeed: UILabel!
    @IBOutlet weak var newFlag: UIImageView!
    @IBOutlet weak var feedTypeImage: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backLbl: UILabel!
    @IBOutlet weak var titleFeed: UITextView!
    @IBOutlet weak var borderLine: UIImageView!
    
    
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var favoriteBtn: UIButton!
    //MARK: Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        titleFeed.textContainerInset = UIEdgeInsetsZero;
        titleFeed.textContainer.lineFragmentPadding = 0;
        newFlag.image = UIImage(named:NSLocalizedString("ic-tag-new", comment: ""))
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Cell Display and Actions
    func setUpCell(index : NSInteger , feedObject : FeedClass , feedType : FeedType){

        shareBtn.tag = index
        favoriteBtn.tag = index
        
        let socialTypeObj  =  SocialType(rawValue:feedObject.socialMediaType)
        feedTypeImage.image = socialTypeObj?.flagImage()
//        titleFeed.textColor = socialTypeObj?.color()
        newFlag.hidden = !feedObject.isNew
        
        if feedObject.isNew{ // new will show only once
          //  CoreData.updateNewOfFeed(feedObject)
        }
        switch feedType{
        case .Upload , .Video , .Youtube :
             playBtn.hidden = false
        default:
            playBtn.hidden = true
        }
        
        favoriteBtn.selected = feedObject.isFavorite 
        
         feedMainImage.kf_setImageWithURL(NSURL(string: CommonFunctions.getImageNameFromCollection(feedObject.imageFeed, thumbnail: true))! , placeholderImage: UIImage(named:"feedDefault"))

        var titleString = feedObject.titleFeed
        if titleString.isEmpty{
            titleString = CommonFunctions.getTitleFromFeed(feedType, socialType: socialTypeObj!, source: nil)
        }
//        backLbl.text = titleString
        CommonFunctions.textViewLineHeight(titleString, titleField: titleFeed , color : socialTypeObj!.color())
        
        let realHeight:CGFloat = CommonFunctions.textViewHeight(titleFeed)
        if(realHeight<30){
            var topCorrect : CGFloat = (titleFeed.frame.height - realHeight);
            topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect / 2
//            titleFeed.contentOffset = CGPoint(x: 0, y: -topCorrect)
            titleFeed.setContentOffset(CGPoint(x: 0, y: -topCorrect), animated: false)
        }
        else{
            titleFeed.setContentOffset(CGPointZero, animated: false)
        }
        subtitleFeed.text = CommonFunctions.formattedString(feedObject.createdTime)
    }
}
