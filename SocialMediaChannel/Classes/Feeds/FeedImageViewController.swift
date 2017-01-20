//
//  FeedImageViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 23/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved. 
//

import UIKit
import Kingfisher

class FeedImageViewController: CommonViewController {
    var imageURL = String()
    @IBOutlet weak var main_Image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForInternetConnections()
        self.setBackButtonWithNavigationTitle("", leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeNone, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: nil)
        main_Image.kf_setImageWithURL(NSURL(string: imageURL)! , placeholderImage: UIImage(named:"feedDefault"))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController as? CommonNavigationViewController {
        nav.menuButtonStatusShow(false)
        }
    }

}
