//
//  OthersFeedImageTypeCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 29/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import Kingfisher

class OthersFeedImageTypeCell: UITableViewCell {

    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgImageBorder: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var newFlag: UIImageView!
    @IBOutlet weak var timeText: UILabel!
    @IBOutlet weak var titleText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newFlag.image = UIImage(named:NSLocalizedString("ic-tag-new", comment: ""))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
        func setUpCell(index : NSInteger, feed : FeedClass , type : FeedType){

            shareBtn.tag = index
            favoriteBtn.tag = index
            newFlag.hidden = !feed.isNew
            favoriteBtn.selected = feed.isFavorite
            
            if feed.isNew{ // new will show only once
            // CoreData.updateNewOfFeed(feed)
            }
            
            switch type{
            case .Upload , .Video , .Youtube, .Bulletin :
                playImage.hidden = false
            default:
                playImage.hidden = true
            }
            let socialType = SocialType(rawValue: feed.socialMediaType)
            if (socialType == SocialType.Instagram) {
                heightConstraint.constant = 0
            }else{
                CommonFunctions.textViewLineHeight(feed.titleFeed, titleField: txtView , color : UIColor.blackColor())
                let height = CommonFunctions.textViewHeight(txtView)
                heightConstraint.constant = height
            }
            self.setNeedsDisplay()
            self.layoutIfNeeded()
           
            let socialTypeObj = SocialType(rawValue: feed.socialMediaType)!
//            titleText.text = CommonFunctions.getTitleFromFeed(type , socialType: socialTypeObj, source: nil)
            timeText.text = CommonFunctions.formattedString(feed.createdTime)
//            CommonFunctions.setBorderWidth(1, color: CommonFunctions.colorWithRGB(229, g: 229, b: 229, a: 1), radius: 0, view: bgImageBorder)
            feedImage.kf_setImageWithURL((NSURL(string: CommonFunctions.getImageNameFromCollection(feed.imageFeed, thumbnail: true))! ), placeholderImage: UIImage(named:"feedDefault"))
    }
}
