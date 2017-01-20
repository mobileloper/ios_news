//
//  Constant.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 17/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit


//MARK: PreDefine Varibles

let kGetFeedsList : String  = "getList?Limit=1000"
let kUpdateNotificationStatus : String = "post"


//MARK: PreDefine Enums
enum LeftButtonTypeEnum {
    /** Button Type will take to reveal the menu */
    case LeftButtonTypeRevealMenu
    /** Button Type will take to pop the view controller */
    case LeftButtonTypeBackNavigation
    /** Button Type will take to pop the view controller and one more Functionaily */
    case LeftButtonTypeBackNavigationWithOptions
    /** Button Type will take no action */
    case LeftButtonTypeNone
    
    init() {
        self = .LeftButtonTypeNone
    }
}
enum RightButtonTypeEnum{
    /** Button Type will be Text type */
    case RightButtonTypeText
    /** Button Type will be Two Image Type*/
    case RightButtonTypeTwoImages
    /** Button Type will be One Image Type*/
    case RightButtonTypeOneImage
    /** Button Type will be None*/
    case RightButtonTypeNone
    
    init() {
        self = .RightButtonTypeNone
    }
}
enum UploadType : Int{
    case FileUpload = 1
    case DataUpload
    case Streamload
    case MultipartFormData
}
enum FeedType : String{
    case Upload = "upload"
    case Video = "video"
    case Text = "text"
    case Status = "status"
    case Photo = "photo"
    case Link = "link"
    case Image = "image"
    case Blog = "blog"
    case Bulletin = "bulletin"
    case Youtube = ""
}

func colorTheme()-> UIColor {
    return UIColor (red: 186/255.0, green: 123/255.0, blue: 167/255.0, alpha: 1)
}
// enum can be initialise with value each enum type has rawValue method'
enum QuickLaunchType : Int {
    case AllFeeds = 0
    case Facebook = 1
    case Twitter =  2
    case Youtube =  3
    case Blog = 4
    case Instagram = 5
    case Favorite = 6
    
    func detailsTab() -> String {
        switch (self) {
        case .Facebook:
            return "Facebook"
        case .Twitter:
            return "Twitter"
        case .Youtube:
            return "YouTube"
        case .Instagram:
            return "Instagram"
        case .Blog:
            return "Blogger"
        case .AllFeeds:
            return NSLocalizedString("All Feeds", comment: "")
        default:
            return "Favorites"
        }
    }
    static func getAllArray()-> [String]{
        return [QuickLaunchType.AllFeeds.detailsTab(),QuickLaunchType.Facebook.detailsTab(),QuickLaunchType.Twitter.detailsTab(),QuickLaunchType.Youtube.detailsTab(),QuickLaunchType.Blog.detailsTab(),QuickLaunchType.Instagram.detailsTab()]
    }
    
}
enum SortOptionType : Int {
    case Date = 0
    case Name = 1
    case Channel =  2
    
    func detailsTab() -> String {
        switch (self) {
        case .Date:
            return NSLocalizedString("Date", comment: "") 
        case .Name:
            return NSLocalizedString("Name", comment: "")
        case .Channel:
            return NSLocalizedString("Channel", comment: "")
        default:
            return ""
        }
    }
    static func getAllArray()-> [String]{
        return [SortOptionType.Date.detailsTab(),SortOptionType.Name.detailsTab(), SortOptionType.Channel.detailsTab()]
    }
    
}
enum SocialType : String {
    case Facebook = "facebook"
    case Twitter = "twitter"
    case Youtube = "youtube"
    case Periscope = "periscope"
    case Instagram = "instagram"
    case Blog = "blog"
    case Favorite = "favorite"
    case All = "allFeeds"
    
    func color() -> UIColor {
        switch (self) {
        case .Facebook:
            return CommonFunctions.colorWithRGB(58, g: 87, b: 149, a: 1)
        case .Twitter:
            return CommonFunctions.colorWithRGB(85, g: 172, b: 238, a: 1)
        case .Youtube:
            return CommonFunctions.colorWithRGB(210, g: 66, b: 73, a: 1)
        case .Instagram:
            return CommonFunctions.colorWithRGB(153, g: 98, b: 77, a: 1)
        case .Periscope:
            return CommonFunctions.colorWithRGB(58, g: 149, b: 178, a: 1)
        case .Blog:
            return CommonFunctions.colorWithRGB(249, g: 141, b: 27, a: 1)
        default:
            return colorTheme()
        }
    }
    
    func flagImage() -> UIImage {
        switch (self) {
        case .Facebook:
            return UIImage(named:"ic-facebook")!
        case .Twitter:
            return UIImage(named:"ic-twitter")!
        case .Youtube:
            return UIImage(named:"ic-Youtube")!
        case .Instagram:
            return UIImage(named:"ic-Instagram")!
        case .Periscope:
            return UIImage(named:"ic_here")!
        case .Blog:
            return UIImage(named:"ic-blog")!
        case .Favorite:
            return UIImage(named:"ic-favorite")!
        case .All:
            return UIImage(named:"ic-icon")!
        default:
            return UIImage(named:"ic-icon")!
        }
    }
    func patchImage() -> UIImage {
        switch (self) {
        case .Facebook:
            return UIImage(named:"facebookPatch")!
        case .Twitter:
            return UIImage(named:"twitterPatch")!
        case .Youtube:
            return UIImage(named:"youtubePatch")!
        case .Instagram:
            return UIImage(named:"instagramPatch")!
        case .Periscope:
            return UIImage(named:"periscopePatch")!
        case .Blog:
            return UIImage(named:"blogPatch")!
        default:
            return UIImage(named:"allFeeds")!
        }
    }
    func getAllPackage() -> (capital: UIColor, flagColours: UIImage , patchImage : UIImage) {
        return (color(), flagImage(), patchImage())
    }
}
