//
//  SettingsTableViewCell.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 20/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var swtichNotication: UISwitch!
    @IBOutlet weak var notificationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        notificationLabel.text = NSLocalizedString("Notification", comment: "")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Cell Actions And Methods
    @IBAction func swtichValueChanged(sender: UISwitch) {
    }
    
    func setUpCell(index : NSInteger){
    }
}
