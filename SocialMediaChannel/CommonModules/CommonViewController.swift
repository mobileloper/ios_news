//
//  CommonViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 16/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import SVProgressHUD
import SystemConfiguration
import SVPullToRefresh
import TLYShyNavBar
class CommonViewController: UIViewController {
    //MARK: Varibles
    var toastView :UIView!
    //MARK: LifeCycle Methods
    override func viewDidLoad() {
         super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.hidesBarsOnSwipe = true
        self.setNavigationAttributes(SocialType.Favorite)
        if let nav = self.navigationController as? CommonNavigationViewController {
        if nav.viewControllers.count == 1{
        nav.setUpMenu()
        }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
         self.view.endEditing(true)
//        self.navigationController?.hidesBarsOnSwipe = false
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
        SVProgressHUD.dismiss()
        super.viewWillDisappear(animated)
    }
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func setNavigationHideOnSwipe(flag : Bool){
        self.navigationController!.hidesBarsOnSwipe = flag
    }
    func setNavigationAttributes(social : SocialType){
        self.navigationController!.navigationBar.translucent = false;
        self.navigationController!.navigationBar.setBackgroundImage(social.patchImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.purpleColor()// UIColor(CGColor: social.color().CGColor)
        self.navigationController!.interactivePopGestureRecognizer!.enabled = true

        let backBtn = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBtn
        
        
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self.navigationController as? UIGestureRecognizerDelegate
        
    }
    func setBackButtonWithNavigationTitle(navigationTitle : NSString?,  var leftButtonType : LeftButtonTypeEnum ,rightButtonType: RightButtonTypeEnum , rightText : NSString? , rightButtonImageRight : NSString?, rightButtonImageleft : NSString?){
        let leftBtn = UIButton(type: UIButtonType.Custom)
        if leftButtonType == .LeftButtonTypeRevealMenu {
            leftButtonType = self.navigationController?.viewControllers.count == 1 ? LeftButtonTypeEnum.LeftButtonTypeRevealMenu : LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions;
        }
        if leftButtonType == .LeftButtonTypeBackNavigationWithOptions {
            leftButtonType = self.navigationController?.viewControllers.count == 1 ? LeftButtonTypeEnum.LeftButtonTypeRevealMenu : LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions;
        }
        switch leftButtonType{
        case .LeftButtonTypeRevealMenu:
            leftBtn.addTarget(self, action:"revealMenu:", forControlEvents:UIControlEvents.TouchUpInside)
            let image = UIImage(named: "ic-thumbnail") as UIImage!
            leftBtn.setImage(image, forState: .Normal)
            leftBtn.setImage(image, forState: UIControlState.Highlighted)
            leftBtn.setImage(image, forState: UIControlState.Selected)
        case .LeftButtonTypeBackNavigation:
            leftBtn.addTarget(self, action:"backButtonClicked:", forControlEvents:UIControlEvents.TouchUpInside)
            let image = UIImage(named: "ic-Back") as UIImage!
            leftBtn.setImage(image, forState: .Normal)
        case .LeftButtonTypeBackNavigationWithOptions:
            leftBtn.addTarget(self, action:"backButtonClicked:", forControlEvents:UIControlEvents.TouchUpInside)
            let image = UIImage(named: "ic-Back") as UIImage!
            leftBtn.setImage(image, forState: .Normal)
        default:
            print("Default", terminator: "")
        }
        leftBtn.frame = CGRectMake(2,3,self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        let leftView = UIView(frame:CGRectMake(0, 0, self.navigationController!.navigationBar.frame.size.height, self.navigationController!.navigationBar.frame.size.height))
        leftView.addSubview(leftBtn)
        if leftButtonType == LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions{
            leftBtn.frame = CGRectMake(-4,3,self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
            
             let leftBtnImage = UIButton(type: UIButtonType.Custom)
            let image = UIImage(named: "ic-thumbnail") as UIImage!
            leftBtnImage.setImage(image, forState: .Normal)
            leftBtnImage.setImage(image, forState: UIControlState.Highlighted)
            leftBtnImage.setImage(image, forState: UIControlState.Selected)
            leftBtnImage.addTarget(self, action:"backButtonClicked:", forControlEvents:UIControlEvents.TouchUpInside)
            leftBtnImage.frame = CGRectMake((self.navigationController!.navigationBar.frame.size.height/2)-5,3,self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
            leftBtnImage.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
             leftView.addSubview(leftBtnImage)
        }
        leftView.backgroundColor = UIColor.clearColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:leftView)
        
        self.navigationItem.rightBarButtonItem = nil
        if rightButtonType == RightButtonTypeEnum.RightButtonTypeNone{
            let rightBtn = UIButton(type: UIButtonType.Custom)
            rightBtn.addTarget(self, action:"rightButtonAction:", forControlEvents:UIControlEvents.TouchUpInside)
            rightBtn.setTitle(rightText as? String, forState: UIControlState.Normal)
            rightBtn.titleLabel?.textColor  = UIColor.whiteColor()
            rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            rightBtn.titleLabel?.font = CommonFunctions.getCalibriRegularFontWithSize(12)
            rightBtn.frame = CGRectMake(5,3,2*self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
            let rightView = UIView(frame:CGRectMake(0, 0, 2*self.navigationController!.navigationBar.frame.size.height, self.navigationController!.navigationBar.frame.size.height))
            rightView.addSubview(rightBtn)
            rightView.backgroundColor = UIColor.clearColor()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightView)
        }
        else if rightButtonType == RightButtonTypeEnum.RightButtonTypeOneImage{
            let rightBtn = UIButton(type: UIButtonType.Custom)
            rightBtn.addTarget(self, action:"rightButtonAction:", forControlEvents:UIControlEvents.TouchUpInside)
            rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            let image = UIImage(named: rightButtonImageleft as! String) as UIImage!
            rightBtn.setImage(image, forState: .Normal)
            rightBtn.frame = CGRectMake(5,3,2*self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
            let rightView = UIView(frame:CGRectMake(0, 0, 2*self.navigationController!.navigationBar.frame.size.height, self.navigationController!.navigationBar.frame.size.height))
            rightView.addSubview(rightBtn)
            rightView.backgroundColor = UIColor.clearColor()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightView)
        }
        else if rightButtonType == RightButtonTypeEnum.RightButtonTypeTwoImages{
            let rightBtn1 = UIButton(type: UIButtonType.Custom)
            rightBtn1.tag = 100
            rightBtn1.addTarget(self, action:"rightButtonAction:", forControlEvents:UIControlEvents.TouchUpInside)
            rightBtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            let image = UIImage(named: rightButtonImageleft as! String) as UIImage!
            rightBtn1.setImage(image, forState: .Normal)
            rightBtn1.frame = CGRectMake(5,3,self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
            let rightBtn2 = UIButton(type: UIButtonType.Custom)
            rightBtn2.tag = 101
            rightBtn2.addTarget(self, action:"rightButtonAction:", forControlEvents:UIControlEvents.TouchUpInside)
            rightBtn2.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
            let image2 = UIImage(named: rightButtonImageRight as! String) as UIImage!
            rightBtn2.setImage(image2, forState: .Normal)
            rightBtn2.frame = CGRectMake(self.navigationController!.navigationBar.frame.size.height+5,3,self.navigationController!.navigationBar.frame.size.height-5,self.navigationController!.navigationBar.frame.size.height-5)
            
            let rightView = UIView(frame:CGRectMake(0, 0, 2*self.navigationController!.navigationBar.frame.size.height, self.navigationController!.navigationBar.frame.size.height))
            rightView.addSubview(rightBtn1)
            rightView.addSubview(rightBtn2)
            rightView.backgroundColor = UIColor.clearColor()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView:rightView)
        }
        
        self.setNavigationTitleLabelWithtext(navigationTitle!)
        self.navigationItem.setHidesBackButton(true, animated: true
        )
    }
    func setNavigationTitleLabelWithtext(navigationTitle : NSString){
        let lblTitle = UILabel(frame:CGRectMake(0,3,180,self.navigationController!.navigationBar.frame.size.height-5))
        lblTitle.text = navigationTitle as String
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.adjustsFontSizeToFitWidth = true
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.font = CommonFunctions.getCalibriBoldFontWithSize(22)
        let titleView = UIView(frame:CGRectMake(0,0,180,self.navigationController!.navigationBar.frame.size.height))
        titleView.addSubview(lblTitle)
        self.navigationItem.titleView = titleView
    }
    
    //MARK: - UIInterfaceOrientationLandscapeLeft my changes
   override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
    return UIInterfaceOrientation.Portrait
    }
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait, UIInterfaceOrientationMask.Landscape]

    }

    //MARK: - Button Actions In Navigation bar
    func rightButtonAction(sender : UIButton!){
        
    }
    func revealMenu(sender : UIButton!){
        
    }
    func backButtonClicked(sender : UIButton!){
        if self.navigationController!.viewControllers.count > 1{
            self.navigationController!.popViewControllerAnimated(true)
        }else{
            self.dismissViewControllerAnimated(true, completion:nil)
        }
    }
    //MARK: - AcitivityViewController
    func shareButtonClicked(textToshare: String , url : String){
        if let myWebsite = NSURL(string:url){
            let objectsToShare = [textToshare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    //MARK: - Network Reachablity
    func checkForInternetConnections()-> Bool{
        if self.isConnectedToNetwork() == true {
            print("Internet connection OK")
            return true
        } else {
            print("Internet connection FAILED")
            self.noInternetAlert()
            return false
        }
    }
    func isConnectedToNetwork()->Bool{
        return true
        /*
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection) ? true : false*/
    }
    func noInternetAlert(){
        let alertController = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
     func showAlertMessageWithTitle(titleStr : String , messageStr : String){
        let alertController = UIAlertController(title: titleStr, message: messageStr, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (action) in
            // ...
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
            // ...
        }
    }
}
