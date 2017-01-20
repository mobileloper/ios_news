//
//  FeedTextTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 27/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class FeedTextTableViewCell: UITableViewCell {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newBtnTopConstraint: NSLayoutConstraint!
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
        if(feed.isNew){
            newBtnTopConstraint.constant = -2;
        }
        else{
            newBtnTopConstraint.constant = -27
        }
        
        favoriteBtn.selected = feed.isFavorite
        
        if feed.isNew{ // new will show only once
          //  CoreData.updateNewOfFeed(feed)
        }
        
        CommonFunctions.textViewLineHeight(feed.titleFeed, titleField: txtView , color : UIColor.blackColor())
        let height = CommonFunctions.textViewHeight(txtView)
        heightConstraint.constant = height+15
        
          self.setNeedsDisplay()
          self.layoutIfNeeded()
        
        let socialTypeObj = SocialType(rawValue: feed.socialMediaType)!
//        titleText.text = CommonFunctions.getTitleFromFeed(type , socialType: socialTypeObj, source: nil)
        timeText.text = CommonFunctions.formattedString(feed.createdTime)
//        CommonFunctions.setBorderWidth(1, color: CommonFunctions.colorWithRGB(229, g: 229, b: 229, a: 1), radius: 0, view: bgImageBorder)
    }
}
