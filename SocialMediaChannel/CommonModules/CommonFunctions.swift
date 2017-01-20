//
//  CommonFunctions.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 17/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

extension NSDate {
    var calendar: NSCalendar {
        return NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    }
    
    func after(value: Int, calendarUnit:NSCalendarUnit) -> NSDate{
        return calendar.dateByAddingUnit(calendarUnit, value: value, toDate: self, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func minus(date: NSDate) -> NSDateComponents{
        return calendar.components(NSCalendarUnit.Minute, fromDate: self, toDate: date, options: NSCalendarOptions(rawValue: 0))
    }
    
    func equalsTo(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedSame
    }
    
    func greaterThan(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedDescending
    }
    
    func lessThan(date: NSDate) -> Bool {
        return self.compare(date) == NSComparisonResult.OrderedAscending
    }
    
    
    class func parse(dateString: String, format: String = "yyyy-MM-dd HH:mm:ss") -> NSDate{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.dateFromString(dateString)!
    }
    
    func toString(format: String = "yyyy-MM-dd HH:mm:ss") -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        return formatter.stringFromDate(self)
    }
    func since() -> String {
        let seconds = abs(NSDate().timeIntervalSince1970 - self.timeIntervalSince1970)
        if seconds <= 120 {
            return NSLocalizedString("just now", comment: "")
        }
        let minutes = Int(floor(seconds / 60))
        if minutes <= 60 {
            let str =  NSLocalizedString("minutes ago", comment: "")
            return "\(minutes) \(str)"
        }
        let hours = minutes / 60
        if hours <= 24 {
            let str =  NSLocalizedString("hrs ago", comment: "")
            return "\(hours) \(str)"
        }
        if hours <= 48 {
            return NSLocalizedString("yesterday", comment: "")
        }
        let days = hours / 24
        if days <= 30 {
            let str =  NSLocalizedString("days ago", comment: "")
            return "\(days) \(str)"
        }
        if days <= 14 {
            return NSLocalizedString("last week", comment: "")
        }
        let months = days / 30
        if months == 1 {
            return NSLocalizedString("last month", comment: "")
        }
        if months <= 12 {
            let str =  NSLocalizedString("months ago", comment: "")
            return "\(months) \(str)"
        }
        let years = months / 12
        if years == 1 {
            return NSLocalizedString("last year", comment: "")
        }
        let str =  NSLocalizedString("years ago", comment: "")
        return "\(years) \(str)"
    }
}

class CommonFunctions: NSObject{
    //MARK: - Font Related Methods
    class func getCalibriRegularFontWithSize(fontsize : CGFloat)-> UIFont?{
        let font = UIFont(name:"Calibri",size: fontsize)
        return font
    }
    class func getCalibriBoldFontWithSize(fontsize : CGFloat)-> UIFont?{
        let font = UIFont(name:"Calibri-Bold",size: fontsize)
        return font!
    }
    class func printFonts() {
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName )
            print("Font Names = [\(names)]")
        }
    }
    //MARK: - Get AppDelegate object
    class func getAppdelegateObject()->AppDelegate{
        let appdelegateObj = UIApplication.sharedApplication().delegate as? AppDelegate
        return appdelegateObj!
    }
    //MARK: - Color and Image Related Methods
    class func colorWithRGB(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)-> UIColor {
        return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
    class func resizableImageWithCapInsets(edgeInsets : UIEdgeInsets, imageName : String)-> UIImage {
        let image = UIImage(named:imageName)?.resizableImageWithCapInsets(edgeInsets, resizingMode: UIImageResizingMode.Stretch)
        return image!
    }
    
    //MARK: - Line Height ,Border, Gradient and Corner
    class func textViewLineHeight(str : String ,titleField : UITextView , color : UIColor){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        let attrString = NSMutableAttributedString(string: NSLocalizedString(str, comment: ""))
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value:CommonFunctions.getCalibriRegularFontWithSize(titleField.font!.pointSize)! , range:NSMakeRange(0, attrString.length))
        //        attrString.addAttribute(NSForegroundColorAttributeName, value:color , range:NSMakeRange(0, attrString.length) )
        titleField.attributedText = attrString
    }
    class func textViewHeight(textView : UITextView)-> CGFloat{
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        return newFrame.size.height
    }
    class func getHeightForTitle(postTitle: NSString, width : CGFloat , font : CGFloat) -> CGFloat {
        // Get the height of the font
        let constraintSize = CGSizeMake(width, CGFloat.max)
        
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(font)]
        let labelSize = postTitle.boundingRectWithSize(constraintSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin ,
            attributes: attributes,
            context: nil)
        
        return labelSize.height
    }
    class func setGradientOfView(view : UIView ,firstColor : UIColor , secondColor : UIColor){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [firstColor.CGColor , secondColor.CGColor]
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    class func setCornerRadius(radius : Float ,view : UIView){
        let viewLayer = view.layer
        viewLayer.cornerRadius = CGFloat(radius)
        viewLayer.masksToBounds = true
    }
    class func setShadowInView(view : UIView){
        let viewLayer = view.layer
        viewLayer.shadowColor = UIColor.blackColor().CGColor
        viewLayer.shadowOffset = CGSizeMake(-1,-1)
        viewLayer.shadowOpacity = 0.5
        viewLayer.shadowRadius = 1.0
        viewLayer.masksToBounds = false
    }
    class func setBorderWidth(width : Float , color : UIColor , radius : Float , view : UIView){
        let viewLayer = view.layer
        if radius > 0{
            viewLayer.cornerRadius = CGFloat(radius)
        }
        if width > 0{
            viewLayer.borderWidth = CGFloat(width)
        }
        viewLayer.borderColor = color.CGColor
        viewLayer.masksToBounds = true
    }
    class func setButtonAttributes(title :String, textColor : UIColor , state : UIControlState, button : UIButton){
        let mySelectedAttributedTitle = NSAttributedString(string: title,
            attributes: [NSForegroundColorAttributeName : textColor])
        button.setAttributedTitle(mySelectedAttributedTitle, forState:state)
    }
    //MARK: - Navigation bar Methods
    class func setNavigationAttributesOnAppearance(){
        UINavigationBar.appearance().backgroundColor = UIColor.clearColor()
        UINavigationBar.appearance().barTintColor = UIColor.clearColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    //MARK: - Basic Operation Methods
    class func performMethod(methodName: String, target : UIViewController, object : String){
        let delay = 0.6 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            NSThread.detachNewThreadSelector(Selector(methodName), toTarget:target, withObject:object)
        })
    }
    class func areTheySiblings(class1: AnyObject!, class2: AnyObject!) -> Bool {
        return object_getClassName(class1) == object_getClassName(class2)
    }
    class func getiOSVersion()->Int{
        return Int(String(Array(UIDevice.currentDevice().systemVersion.characters)[0]))!
    }
    class func setImageOnButton(btn : UIButton , image : UIImage){
        btn.setImage(image, forState: UIControlState.Normal)
        btn.setImage(image, forState: UIControlState.Highlighted)
        btn.setImage(image, forState: UIControlState.Selected)
    }
    //MARK: - StatusCode And Http Request
    class func isSuccessfullyDone(code : Int?)-> (flag:  Bool, String: String){
        if let _ = code{
            switch code!{
            case 200, 201, 202, 203, 204:
                return (true, "Successfull")
            default:
                return (false , "Fail")
            }
        }else{
            return (false , "Fail")
        }
    }
    //MARK: - Null case checks
    class func checkStringForNull(value : AnyObject?)-> String{
        if let _ : String = value as? String{
            return value as! String
        }else{
            return ""
        }
    }
    class func checkIntForNull(value : AnyObject?)-> Int32{
        if let _ : Int32 = value as? Int32{
            return value as! Int32
        }else{
            return 0
        }
    }
    class func getDocumentPath()->String{
        let documentsPath : String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
        print(documentsPath, terminator: "")
        return documentsPath
    }
    //MARK: - Database Replace From Bundle
    class func checkForSquiteDatabase(){
        let paths =  CommonFunctions.getDocumentPath() as NSString
//        let writePath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent("instagram.igo")

        let getImagePath = paths.stringByAppendingPathComponent("SocialMediaChannel.sqlite")
        let checkValidation = NSFileManager.defaultManager()
        
        if (checkValidation.fileExistsAtPath(getImagePath)){
            print("FILE AVAILABLE")
        }else{
            print("FILE NOT AVAILABLE NEED TO COPY FROM BUNDLE")
            let sourcePath = NSBundle.mainBundle().pathForResource("SocialMediaChannel", ofType:"sqlite")
            do {
                try NSFileManager.defaultManager().copyItemAtPath(sourcePath!, toPath: getImagePath)
                print("Successfully copy done")
            } catch _ {
                print("failed to copy")
            }
        }
    }
    //MARK: - Project Methods
    class func getImageNameFromCollection(name : String , thumbnail : Bool)-> String{
        let arrDifferentImages = name.componentsSeparatedByString("__")
        
        if arrDifferentImages.count > 0{
            let firstObj = arrDifferentImages.first
            let arrSameImageSet = firstObj!.componentsSeparatedByString(",")
            
            if(arrSameImageSet.count > 0){
                if(arrSameImageSet.count >= 3){
                    return arrSameImageSet.last!
                    /*
                    if thumbnail{
                        return arrSameImageSet[1]
                    }else{
                        return  arrSameImageSet.last!
                    }*/
                }else{
                    return arrSameImageSet.last!
                }
            }else{
                return ""
            }
        }else{
            return ""
        }
    }
    class func getTitleFromFeed(feedType : FeedType , socialType : SocialType , source : String?)-> String{
        var resultString = String()
        
        switch socialType{
        case .Facebook:
            switch feedType{
            case .Link:
                resultString = NSLocalizedString("Sebi Bebi shared a page", comment: "")
            case .Video:
                resultString = NSLocalizedString("Sebi Bebi shared a video", comment: "")
            case .Upload:
                resultString = NSLocalizedString("Sebi Bebi uploaded a video", comment: "")
            case .Image , .Photo:
                resultString = NSLocalizedString("Sebi Bebi uploaded a image", comment: "")
            case .Text , .Status:
                resultString = NSLocalizedString("Sebi Bebi posted a status update", comment: "")
            default:
                resultString = NSLocalizedString("Sebi Bebi shared a post", comment: "")
            }
        case .Twitter:
            
            switch feedType{
            case .Link:
                resultString = NSLocalizedString("Sebi Bebi shared a page", comment: "")
            case .Video:
                resultString = NSLocalizedString("Sebi Bebi shared a video", comment: "")
            case .Upload:
                resultString = NSLocalizedString("Sebi Bebi uploaded a video", comment: "")
            case .Image , .Photo:
                resultString = NSLocalizedString("Sebi Bebi uploaded a image", comment: "")
            case .Text , .Status:
                resultString = NSLocalizedString("Sebi Bebi posted a status update", comment: "")
            default:
                resultString = NSLocalizedString("Sebi Bebi shared a post", comment: "")
            }
        case .Blog:
            switch feedType{
            case .Link:
                resultString = NSLocalizedString("Sebi Bebi shared a page", comment: "")
            default:
                resultString = NSLocalizedString("Sebi Bebi shared a post", comment: "")
            }
        case .Instagram:
            switch feedType{
            case .Image , .Photo:
                resultString = NSLocalizedString("Sebi Bebi uploaded a image", comment: "")
            case .Video , .Youtube , .Upload:
                resultString = NSLocalizedString("Sebi Bebi uploaded a video", comment: "")
            default:
                resultString = NSLocalizedString("Sebi Bebi shared a post", comment: "")
            }
        default:
            resultString = NSLocalizedString("Sebi Bebi shared a post", comment: "")
        }
        return resultString
    }
    class func formattedString(dateString : String ) -> String{
        let string : String = dateString
        let timeinterval : NSTimeInterval = (string as NSString).doubleValue // convert it in to NSTimeInteral
        let dateFromServer = NSDate(timeIntervalSince1970:timeinterval) // you can the Date object from here
        let returnObject = dateFromServer.since()
        return returnObject
    }
}
