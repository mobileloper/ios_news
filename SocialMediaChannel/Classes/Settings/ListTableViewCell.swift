//
//  ListTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 20/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var defaultTypeText: UILabel!
    @IBOutlet weak var defaultOpeningtab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultOpeningtab.text = NSLocalizedString("Default Opening Tab", comment: "")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setUpCell(str : String){
        defaultTypeText.text = str
    }
}
