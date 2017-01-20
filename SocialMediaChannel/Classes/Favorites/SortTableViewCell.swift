//
//  SortTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 24/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet weak var selectImage: UIImageView!
    @IBOutlet weak var sortOption: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpCell(title : String , isSelected : Bool){
        sortOption.setTitle(title, forState: UIControlState.Normal)
        sortOption.setTitle(title, forState: UIControlState.Highlighted)
        sortOption.setTitle(title, forState: UIControlState.Selected)
        
        if isSelected {
            sortOption.titleLabel?.font = CommonFunctions.getCalibriBoldFontWithSize(sortOption.titleLabel!.font.pointSize)
            self.backgroundColor = CommonFunctions.colorWithRGB(248, g: 248, b: 248, a: 1)
           sortOption.setTitleColor(colorTheme(), forState: UIControlState.Normal)
        }else{
            sortOption.titleLabel?.font = CommonFunctions.getCalibriRegularFontWithSize(sortOption.titleLabel!.font.pointSize)
            self.backgroundColor = UIColor.whiteColor()
            sortOption.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
         selectImage.hidden = !isSelected
    }
}
