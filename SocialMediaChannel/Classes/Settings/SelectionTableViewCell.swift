//
//  SelectionTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 22/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImg: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupCell(title : String , flag : Bool){
        titleText.text = title
        checkImg.hidden = !flag
    }
}
