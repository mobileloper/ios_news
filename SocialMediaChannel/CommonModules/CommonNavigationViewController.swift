//
//  CommonNavigationViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 27/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

let kBadgeTag = 100
let kBaseTag = 200
let kMenuTag = 300




class CommonNavigationViewController: UINavigationController {
    var menuBtn = UIButton()
    var favoriteBtn = UIButton()
    var allFeedsBtn = UIButton()
    var instagramBtn = UIButton()
    var blogBtn = UIButton()
    var youtubeBtn = UIButton()
    var twitterBtn = UIButton()
    var facebookBtn = UIButton()
    var quickLaunchView = UIView()
    var quickLaunchFlag : Bool = false
    var boolForRotation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Quick Launch SetUp Methods
    func menuButtonStatusShow(flag : Bool){
        menuBtn.hidden = !flag
        if let btn = menuBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = !flag
            if(!btn.hidden && Int(btn.titleLabel!.text!) == 0){
                btn.hidden = true
            }
        }
        if(!flag){
            hideMenuCountStatus(true)
        }
        self.view.bringSubviewToFront(menuBtn)
    }
    func setUpMenu(){
        backGroundWithGesture()
        menuButtonSetup()
        optionsButtonSetup()
        hideMenuCountStatus(true)
        //         addBadgeCountLabel()
    }
    func backGroundWithGesture(){
        if let gesture = self.view.viewWithTag(kBadgeTag){
            // already there
        }else{
            quickLaunchView = UIView()
            let tapGesture = UITapGestureRecognizer(target: self, action:"hideQuickLaunch")
            tapGesture.cancelsTouchesInView = false
            quickLaunchView.tag = kBadgeTag
            quickLaunchView.addGestureRecognizer(tapGesture)
            quickLaunchView.frame = self.view.frame
            self.view.addSubview(quickLaunchView)
            quickLaunchView.backgroundColor = CommonFunctions.colorWithRGB(255, g: 255, b: 255, a: 0.5)
            quickLaunchView.hidden = true
        }
    }
    
    
    
    func setMenuImage(str : String){
        menuBtn.setImage(UIImage(named:str), forState: UIControlState.Normal)
        menuBtn.setImage(UIImage(named:str), forState: UIControlState.Highlighted)
        menuBtn.setImage(UIImage(named:str), forState: UIControlState.Selected)
    }
    func menuButtonSetup(){
        if let menu = self.view.viewWithTag(kMenuTag) as? UIButton{
            // already there
        }else{
            print(self.view, terminator: "")
            menuBtn  = UIButton(type: UIButtonType.Custom)
            menuBtn.showsTouchWhenHighlighted = true
            setMenuImage("ic-Menu")
            menuBtn.addTarget(self, action: "menuBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            menuBtn.tag = kMenuTag
            self.view .addSubview(menuBtn)
            menuBtn.translatesAutoresizingMaskIntoConstraints = false
            
            let horizontalConstraint = NSLayoutConstraint(item: menuBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 60)
            menuBtn.addConstraint(horizontalConstraint)
            
            let verticalConstraint = NSLayoutConstraint(item: menuBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 60)
            menuBtn.addConstraint(verticalConstraint)
            
            let bottom = NSLayoutConstraint(item: menuBtn, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
            self.view.addConstraint(bottom)
            
            let right = NSLayoutConstraint(item: menuBtn, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant:-20)
            self.view.addConstraint(right)
        }
        let frame : CGRect = self.view.frame
        menuBtnFrameSet(frame)
    }
    func menuBtnFrameSet(frame : CGRect){
        menuBtn.translatesAutoresizingMaskIntoConstraints = false
        // menuBtn.frame = CGRectMake(frame.size.width-85, frame.size.height-80, 60, 60)
        
    }
    func optionsButtonSetup(){
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.Favorite.rawValue) as? UIButton{
            // already there
        }else{
            favoriteBtn = UIButton(type: UIButtonType.Custom)
            favoriteBtn.showsTouchWhenHighlighted = true
            favoriteBtn.tag = QuickLaunchType.Favorite.rawValue + kBaseTag
            
            self.view.addSubview(favoriteBtn)
            CommonFunctions.setImageOnButton(favoriteBtn, image: SocialType.Favorite.flagImage())
            favoriteBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.AllFeeds.rawValue) as? UIButton{
            // already there
        }else{
            allFeedsBtn = UIButton(type: UIButtonType.Custom)
            allFeedsBtn.showsTouchWhenHighlighted = true
            allFeedsBtn.tag = QuickLaunchType.AllFeeds.rawValue + kBaseTag
            
            CommonFunctions.setImageOnButton(allFeedsBtn, image: SocialType.All.flagImage())
            allFeedsBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(allFeedsBtn)
        }
        
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.Instagram.rawValue) as? UIButton{
            // already there
        }else{
            instagramBtn = UIButton(type: UIButtonType.Custom)
            instagramBtn.showsTouchWhenHighlighted = true
            instagramBtn.tag = QuickLaunchType.Instagram.rawValue + kBaseTag
            
            CommonFunctions.setImageOnButton(instagramBtn, image: SocialType.Instagram.flagImage())
            instagramBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(instagramBtn)
        }
        
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.Blog.rawValue) as? UIButton{
            // already there
        }else{
            blogBtn = UIButton(type: UIButtonType.Custom)
            blogBtn.showsTouchWhenHighlighted = true
            blogBtn.tag = QuickLaunchType.Blog.rawValue + kBaseTag
            
            CommonFunctions.setImageOnButton(blogBtn, image: SocialType.Blog.flagImage())
            blogBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(blogBtn)
        }
        
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.Youtube.rawValue) as? UIButton{
            // already there
        }else{
            youtubeBtn = UIButton(type: UIButtonType.Custom)
            youtubeBtn.showsTouchWhenHighlighted = true
            youtubeBtn.tag = QuickLaunchType.Youtube.rawValue + kBaseTag
            
            CommonFunctions.setImageOnButton(youtubeBtn, image: SocialType.Youtube.flagImage())
            youtubeBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(youtubeBtn)
        }
        
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.Twitter.rawValue) as? UIButton{
            // already there
        }else{
            twitterBtn = UIButton(type: UIButtonType.Custom)
            twitterBtn.showsTouchWhenHighlighted = true
            twitterBtn.tag = QuickLaunchType.Twitter.rawValue + kBaseTag
            
            CommonFunctions.setImageOnButton(twitterBtn, image: SocialType.Twitter.flagImage())
            twitterBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.view.addSubview(twitterBtn)
        }
        
        if let menu = self.view.viewWithTag(kBaseTag + QuickLaunchType.Facebook.rawValue) as? UIButton{
            // already there
        }else{
            facebookBtn = UIButton(type: UIButtonType.Custom)
            facebookBtn.showsTouchWhenHighlighted = true
            facebookBtn.tag = QuickLaunchType.Facebook.rawValue + kBaseTag
            
            facebookBtn.addTarget(self, action: "optionsBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            CommonFunctions.setImageOnButton(facebookBtn, image: SocialType.Facebook.flagImage())
            self.view.addSubview(facebookBtn)
            setRotateButton(CGFloat(-M_PI))
        }
        
        self.view.bringSubviewToFront(menuBtn)
    }
    func addBadgeOnButton(btn : UIButton){
        if  let btnCircle = btn.viewWithTag(kBadgeTag) as? UIButton {
            // already have circle button
        }else{
            let badgeCount: UIButton = UIButton(type: UIButtonType.Custom)
            badgeCount.frame =  CGRectMake(-5, -5, 25, 25)
            badgeCount.tag = kBadgeTag // fixed for badge
            badgeCount.backgroundColor = UIColor.clearColor()
            badgeCount.setBackgroundImage(UIImage(named:"ic-Red-Pop"), forState: UIControlState.Normal)
            badgeCount.contentMode = UIViewContentMode.ScaleAspectFill
            badgeCount.clipsToBounds = true
            badgeCount.titleLabel?.font = CommonFunctions.getCalibriBoldFontWithSize(11)
            CommonFunctions.setCornerRadius(12, view: badgeCount)
            badgeCount.userInteractionEnabled = false
            btn.addSubview(badgeCount)
        }
    }
    func addBadgeCountLabel(){
        addBadgeOnButton(menuBtn)
        setCountValueTolabel()
        setFavoritesCount()
    }
    func setFavoritesCount(){
//        addBadgeOnButton(favoriteBtn)
        if let btn = favoriteBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.setTitle("\(CoreData.countOfSocialType(SocialType.Favorite))", forState: UIControlState.Normal)
        }
    }
    
    func setMainMenuCountValueTolabel(){
        addBadgeOnButton(menuBtn)
        if let btn = menuBtn.viewWithTag(kBadgeTag) as? UIButton{
            
            let count = CoreData.countOfSocialType(SocialType.All)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.setTitle("\(count)", forState: UIControlState.Normal)
                btn.hidden = false
            }
        }
    }
    func setCountValueTolabel(){
        
        if let btn = menuBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.All)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        addBadgeOnButton(facebookBtn)
        if let btn = facebookBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.Facebook)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        addBadgeOnButton(allFeedsBtn)
        if let btn = allFeedsBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.All)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        addBadgeOnButton(twitterBtn)
        if let btn = twitterBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.Twitter)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        addBadgeOnButton(youtubeBtn)
        if let btn = youtubeBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.Youtube)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        addBadgeOnButton(instagramBtn)
        if let btn = instagramBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.Instagram)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        addBadgeOnButton(blogBtn)
        if let btn = blogBtn.viewWithTag(kBadgeTag) as? UIButton{
            let count = CoreData.countOfSocialType(SocialType.Blog)
            if count == 0{
                btn.hidden = true
            }
            else{
                btn.hidden = false
            }
            btn.setTitle("\(count)", forState: UIControlState.Normal)
        }
        
    }
    func hideMenuCountStatus(flag : Bool){
        if let btn = menuBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = !flag
            if(!btn.hidden && Int(btn.titleLabel!.text!) == 0){
                btn.hidden = true
            }
        }
        if let btn = facebookBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
        if let btn = favoriteBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
        if let btn = allFeedsBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
        if let btn = twitterBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
        if let btn = youtubeBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
        if let btn = instagramBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
        if let btn = blogBtn.viewWithTag(kBadgeTag) as? UIButton{
            btn.hidden = flag
        }
    }
    //MARK: - Action Methods Of QL
    func setRotateButton(angle : CGFloat){
        favoriteBtn.transform = CGAffineTransformRotate(favoriteBtn.transform, angle);
        allFeedsBtn.transform = CGAffineTransformRotate(allFeedsBtn.transform, angle);
        instagramBtn.transform = CGAffineTransformRotate(instagramBtn.transform, angle);
        blogBtn.transform = CGAffineTransformRotate(blogBtn.transform, angle);
        youtubeBtn.transform = CGAffineTransformRotate(youtubeBtn.transform, angle);
        facebookBtn.transform = CGAffineTransformRotate(facebookBtn.transform, angle);
        twitterBtn.transform = CGAffineTransformRotate(twitterBtn.transform, angle);
    }
    func setRotateOfButtonWithFrame(angle : CGFloat , btn : UIButton , frame : CGRect){
        btn.transform = CGAffineTransformRotate(btn.transform, angle);
        btn.frame = frame
    }
    func setAllBtnFrame(frame : CGRect){
        favoriteBtn.frame = frame
        allFeedsBtn.frame = frame
        facebookBtn.frame = frame
        twitterBtn.frame = frame
        youtubeBtn.frame = frame
        instagramBtn.frame = frame
        blogBtn.frame = frame
    }
    func hideQuickLaunch(){
        
        if quickLaunchFlag{
            return
        }
        var frame = menuBtn.frame
        frame.origin.x = frame.origin.x+30
        frame.origin.y = frame.origin.y+30
        frame.size.width = 0
        frame.size.height = 0
        setAllBtnFrame(frame)
        quickLaunchView.hidden = true
        menuBtn.selected = false
        quickLaunchFlag = false
        if !boolForRotation{
            self.setRotateButton(CGFloat(-M_PI))
            boolForRotation = true
            
        }
        self.setMenuImage("ic-Menu")
        self.hideMenuCountStatus(true)
    }
    func repeatedRotation(sender : UIButton , angle : CGFloat){
        let rotationAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotationAnimation.toValue = CGFloat(angle);
        rotationAnimation.duration = 0.5;
        rotationAnimation.cumulative = true;
        rotationAnimation.repeatCount = 1;
        sender.layer.addAnimation(rotationAnimation, forKey:"rotationAnimation")
    }
    func menuBtnTapped(sender: UIButton){
        if quickLaunchFlag{
            return
        }
        quickLaunchFlag = true
        
        if sender.selected{
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
                self.setRotateButton(CGFloat(-M_PI))
                self.quickLaunchView.alpha = 0.0
                var frameReset = sender.frame
                frameReset.origin.x = frameReset.origin.x+30
                frameReset.origin.y = frameReset.origin.y+30
                frameReset.size = CGSizeMake(10, 10)
                self.setAllBtnFrame(frameReset)
                self.repeatedRotation(sender, angle: CGFloat(-2*M_PI))
                
                }, completion: { finished in
                    self.boolForRotation = true;
                    self.setMenuImage("ic-Menu")
                    self.quickLaunchView.hidden = true
                    var frameReset = sender.frame
                    frameReset.origin.x = frameReset.origin.x+30
                    frameReset.origin.y = frameReset.origin.y+30
                    frameReset.size.width = 0
                    frameReset.size.height = 0
                    self.setAllBtnFrame(frameReset)
                    self.quickLaunchFlag = false
                    self.hideMenuCountStatus(true)
                    //                    self.addBadgeCountLabel()
            })
        }
            
        else{
            let jumpSize : CGFloat = 45
            let jumpX = self.view.frame.size.width
            let jumpY = self.view.frame.size.height
            let frame = self.view.frame
            
            UIView.animateWithDuration(0.05, animations: {
                self.setMenuImage("ic-cancel")
                var frameReset = sender.frame
                frameReset.origin.x = frameReset.origin.x+20
                frameReset.origin.y = frameReset.origin.y+20
                frameReset.size.width = 0
                frameReset.size.height = 0
                self.setAllBtnFrame(frameReset)
                self.quickLaunchView.frame = frame
                
                }, completion: { finished in
                    self.boolForRotation = false;
                    UIView.animateWithDuration(0.15, delay: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
                        self.quickLaunchView.hidden = false
                        self.quickLaunchView.alpha = 1.0
                        self.hideMenuCountStatus(false)
                        self.addBadgeCountLabel()
                        self.repeatedRotation(sender, angle: CGFloat(2*M_PI))
                        let frameFacebook : CGRect = CGRectMake(jumpX-jumpSize-225, jumpY-jumpSize-30, jumpSize, jumpSize)
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.facebookBtn, frame: frameFacebook)
                        }, completion: { finished in
                            self.quickLaunchView.alpha = 1.0
                    })
                    UIView.animateWithDuration(0.15, delay: 0.10, options: UIViewAnimationOptions.TransitionNone, animations: {
                        let frameTwiiter : CGRect = CGRectMake(jumpX-jumpSize-210, jumpY-jumpSize-105, jumpSize, jumpSize)
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.twitterBtn, frame: frameTwiiter)
                        }, completion: { finished in
                            
                    })
                    UIView.animateWithDuration(0.15, delay: 0.2, options: UIViewAnimationOptions.TransitionNone, animations: {
                        let frameYouTube : CGRect = CGRectMake(jumpX-jumpSize-170, jumpY-jumpSize-170, jumpSize, jumpSize)
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.youtubeBtn, frame: frameYouTube)
                        }, completion: { finished in
                            
                    })
                    UIView.animateWithDuration(0.15, delay: 0.3, options: UIViewAnimationOptions.TransitionNone, animations: {
                        let frameBlog : CGRect = CGRectMake(jumpX-jumpSize-105, jumpY-jumpSize-210, jumpSize, jumpSize)
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.blogBtn, frame: frameBlog)
                        }, completion: { finished in
                            
                    })
                    UIView.animateWithDuration(0.15, delay: 0.4, options: UIViewAnimationOptions.TransitionNone, animations: {
                        let frameInstaGram : CGRect = CGRectMake(jumpX-jumpSize-30, jumpY-jumpSize-225, jumpSize, jumpSize)
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.instagramBtn, frame: frameInstaGram)
                        }, completion: { finished in
                            
                    })
                    UIView.animateWithDuration(0.15, delay: 0.5, options: UIViewAnimationOptions.TransitionNone, animations: {
                        let frameFavo : CGRect = CGRectMake(jumpX-jumpSize-75, jumpY-jumpSize-125, jumpSize, jumpSize)
                        let frameAll : CGRect = CGRectMake(jumpX-jumpSize-125, jumpY-jumpSize-75, jumpSize, jumpSize)
                        
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.favoriteBtn, frame: frameFavo)
                        self.setRotateOfButtonWithFrame(CGFloat(M_PI), btn: self.allFeedsBtn, frame: frameAll)
                        }, completion: { finished in
                            self.quickLaunchFlag = false
                            
                    })
            })
        }
        sender.selected = !sender.selected
    }
    func optionsBtnTapped(sender : UIButton){
        self.hideQuickLaunch()
        switch (sender.tag - kBaseTag) as QuickLaunchType.RawValue{
        case QuickLaunchType.Youtube.rawValue:
            if self.visibleViewController!.isKindOfClass(SocialFeedsViewController().classForCoder){
                
            }else{
                let newVC : SocialFeedsViewController = SocialFeedsViewController(nibName:"SocialFeedsViewController", bundle: nil)
                checkSiblings(newVC)
                if self.viewControllers.count > 2{
                    CommonFunctions.performMethod("updateStackOfViewController", target:self, object:"updateStack")
                }            }
        case QuickLaunchType.AllFeeds.rawValue:
            if self.visibleViewController!.isKindOfClass(FeedsViewController().classForCoder){
                
            }else{
                let newVC : FeedsViewController = FeedsViewController(nibName:"FeedsViewController", bundle: nil)
                checkSiblings(newVC)
                if self.viewControllers.count > 2{
                    CommonFunctions.performMethod("updateStackOfViewController", target:self, object:"updateStack")
                }            }
        case QuickLaunchType.Favorite.rawValue:
            if self.visibleViewController!.isKindOfClass(FavoritesViewController().classForCoder){
                
            }else{
                let newVC : FavoritesViewController = FavoritesViewController(nibName:"FavoritesViewController", bundle: nil)
                
                checkSiblings(newVC)
                if self.viewControllers.count > 2{
                    CommonFunctions.performMethod("updateStackOfViewController", target:self, object:"updateStack")
                }
            }
        default:
            var social : SocialType
            switch (sender.tag - kBaseTag) as QuickLaunchType.RawValue{
            case QuickLaunchType.Facebook.rawValue:
                social = SocialType.Facebook
            case QuickLaunchType.Twitter.rawValue:
                social = SocialType.Twitter
            case QuickLaunchType.Instagram.rawValue:
                social = SocialType.Instagram
            case QuickLaunchType.Blog.rawValue:
                social = SocialType.Blog
            default:
                social = SocialType.Facebook
            }
            if self.visibleViewController!.isKindOfClass(OthereFeedsViewController().classForCoder){
                var other : OthereFeedsViewController = self.visibleViewController as! OthereFeedsViewController
                if other.socialType == social{
                    
                }else{
                    let newVC : OthereFeedsViewController = OthereFeedsViewController(nibName:"OthereFeedsViewController", bundle: nil)
                    newVC.socialType = social
                    checkSiblings(newVC)
                    
                    if self.viewControllers.count > 2{
                        CommonFunctions.performMethod("updateStackOfViewController", target:self, object:"updateStack")
                    }
                }
            }else{
                let newVC : OthereFeedsViewController = OthereFeedsViewController(nibName:"OthereFeedsViewController", bundle: nil)
                newVC.socialType = social
                checkSiblings(newVC)
                if self.viewControllers.count > 2{
                    CommonFunctions.performMethod("updateStackOfViewController", target:self, object:"updateStack")
                }
            }
        }
    }
    func checkSiblings(newVC : CommonViewController){
        if CommonFunctions.areTheySiblings(self.viewControllers[0], class2: newVC){
            if newVC.isKindOfClass(OthereFeedsViewController.classForCoder()){
                let listStack = self.viewControllers[0] as! OthereFeedsViewController
                let listStackNew = newVC as! OthereFeedsViewController
                if listStack.socialType == listStackNew.socialType{
                    self.popToRootViewControllerAnimated(true)
                }else{
                    self.pushViewController(newVC, animated: true)
                }
            }else{
                self.popToRootViewControllerAnimated(true)
            }
        }else{
            self.pushViewController(newVC, animated: true)
        }
    }
    func updateStackOfViewController(){
        let listStack = self.viewControllers
        let newStack = [self.viewControllers[0],self.viewControllers[listStack.count-1]]
        self.setViewControllers(newStack, animated: false)
    }
}
