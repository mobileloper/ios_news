//
//  OthereFeedsViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 27/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer

class OthereFeedsViewController: CommonViewController , UITableViewDelegate , UITableViewDataSource , NSFetchedResultsControllerDelegate {
   //MARK: - Varibles
    @IBOutlet weak var tbl_Listing: UITableView!
    var refreshControl = UIRefreshControl()
    var socialType : SocialType = SocialType.Facebook
    
    //MARK: - FetchedResultController Setup
    lazy var feedsFetchResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setUpNavigationBar()
        fetchedSetup()
        sendFeedsRequest(true)
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Right Button Action and Setup
    override func rightButtonAction(sender : UIButton!){
        let setting : SettingsViewController = SettingsViewController(nibName:"SettingsViewController", bundle: nil)
        self.navigationController!.pushViewController(setting, animated: true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController as? CommonNavigationViewController{
        nav.menuButtonStatusShow(true)
        }
        self.setNavigationAttributes(socialType)
    }
    
    //MARK: - StartUp Method
    func setUpNavigationBar(){
        var title : String = socialType.rawValue as String
        title = title.capitalizedString
        title = title+"-feeds"
        title = NSLocalizedString(title, comment: "")
        self.setBackButtonWithNavigationTitle(title, leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeOneImage, rightText: nil, rightButtonImageRight:nil , rightButtonImageleft:"ic-settings")
    }
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    }
    
    //MARK: - TableView Delegate and DataSource
    func configureTableView() {
        tbl_Listing.rowHeight = UITableViewAutomaticDimension
        tbl_Listing.estimatedRowHeight = 100
        tbl_Listing.registerNib(UINib(nibName:"OthersFeedImageTypeCell", bundle: nil), forCellReuseIdentifier: "otherMediaCell")
        tbl_Listing.registerNib(UINib(nibName:"FeedTextTableViewCell", bundle: nil), forCellReuseIdentifier: "otherTextCell")
        refreshControl.tintColor = socialType.color()
        refreshControl.addTarget(self, action:"pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tbl_Listing.addSubview(refreshControl)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return feedsFetchResultController.fetchedObjects!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        var cell : UITableViewCell = UITableViewCell()
        
        let feedObject = feedsFetchResultController.objectAtIndexPath(indexPath) as! FeedClass
        let feedTypeObj = FeedType(rawValue:feedObject.feedType)
        if feedTypeObj == FeedType.Text || feedTypeObj  == FeedType.Status {
          let cellInstance : FeedTextTableViewCell = tableView.dequeueReusableCellWithIdentifier("otherTextCell") as! FeedTextTableViewCell
            cellInstance.shareBtn.addTarget(self, action: "shareBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cellInstance.favoriteBtn.addTarget(self, action: "favoriteBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cellInstance.setUpCell(indexPath.row, feed: feedObject, type: feedTypeObj!)
            cell = cellInstance
        }else{
            let cellInstance : OthersFeedImageTypeCell = tableView.dequeueReusableCellWithIdentifier("otherMediaCell") as! OthersFeedImageTypeCell
            cellInstance.shareBtn.addTarget(self, action: "shareBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cellInstance.favoriteBtn.addTarget(self, action: "favoriteBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cellInstance.setUpCell(indexPath.row, feed: feedObject, type: feedTypeObj!)
            cell = cellInstance
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedObj: FeedClass = feedsFetchResultController.objectAtIndexPath(indexPath) as! FeedClass
        let feedTypeObj : FeedType = FeedType(rawValue:feedObj.feedType)!
        if feedObj.isNew == true {
            CoreData.updateNewOfFeed(feedObj)
        }
        
        switch feedTypeObj{
            
        case FeedType.Video ,FeedType.Upload: // type video and social type instagram thn mp4 file
            let socialType = SocialType(rawValue: feedObj.socialMediaType)
            let arrVideoes = feedObj.videoFeed.componentsSeparatedByString(",")
            if socialType == SocialType.Instagram{ // mp4 file
                if arrVideoes.count > 0{
                    let urlString = arrVideoes.first!
                    let url : NSURL! = NSURL(string: urlString)
                    let movieplayer = MPMoviePlayerViewController(contentURL: url)
                    movieplayer.moviePlayer.play()
                    self.presentMoviePlayerViewControllerAnimated(movieplayer)
                }
            }else if socialType == SocialType.Youtube{
                
                let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
                if arrVideoes.count > 0{
                    feedWeb.urlString = arrVideoes.first!
                    self.navigationController!.pushViewController(feedWeb, animated: true)
                }
                return
/*
                let feedVideo : FeedVideoViewController  = FeedVideoViewController(nibName:"FeedVideoViewController", bundle: nil)
                let arrVideoID = feedObj.videoFeed.componentsSeparatedByString("watch?v=")
                if arrVideoID.count == 2{
                    feedVideo.videoID = arrVideoID.last!
                    self.navigationController!.pushViewController(feedVideo, animated: true)
                }
                */
            }else{
                let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
                if arrVideoes.count > 0{
                    feedWeb.urlString = arrVideoes.first!
                    self.navigationController!.pushViewController(feedWeb, animated: true)
                }
            }
        case FeedType.Photo , FeedType.Image:
            if socialType == SocialType.Instagram{
                let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
                feedWeb.urlString = feedObj.linkFeed
                self.navigationController!.pushViewController(feedWeb, animated: true)
                return
            }

            let feedImage : FeedImageViewController  = FeedImageViewController(nibName:"FeedImageViewController", bundle: nil)
            feedImage.imageURL = CommonFunctions.getImageNameFromCollection(feedObj.imageFeed, thumbnail: false)
            self.navigationController!.pushViewController(feedImage, animated: true)
            
        case FeedType.Blog , FeedType.Link :
            let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
            feedWeb.urlString = feedObj.linkFeed
            
            self.navigationController!.pushViewController(feedWeb, animated: true)
            
        case FeedType.Youtube:
            let feedVideo : FeedVideoViewController  = FeedVideoViewController(nibName:"FeedVideoViewController", bundle: nil)
            let arrVideoID = feedObj.videoFeed.componentsSeparatedByString("watch?v=")
            if arrVideoID.count == 2{
                feedVideo.videoID = arrVideoID.last!
                self.navigationController!.pushViewController(feedVideo, animated: true)
            }
        default:
            print("do nothing", terminator: "")
        }
    }
    
    //MARK: - Requests, Pull to refresh
    func sendFeedsRequest(animation : Bool){
        // if previous
        let tuple = CoreData.fetchTopMostFeedWithType(socialType)
        if let _ = tuple{
            self.sendFeedsRequestUpdated(animation, time: tuple!.0)
        }
    }
    func pullToRefresh(){
        sendFeedsRequest(false)
    }
    //MARK : Http Requests
    func sendFeedsRequestUpdated(animation : Bool , time : Int32){ // PullToRefresh Request
        if animation {
           // SVProgressHUD.show()
        }
        var url = kGetFeedsList+"&direction=previous&social_media_type=\(socialType.rawValue)"
        if time != 0 {
            url = url + "&id=\(time)"
        }
        NetworkClass.responseWithUrl(url, parameter: nil, requestType:RequestType.GET, tagString:"Feeds") { (status, responseObj, error, statusCode, tag) in
            dispatch_async(dispatch_get_main_queue()) {
//                var alert = UIAlertView(title: "test1", message: "", delegate: nil, cancelButtonTitle: "Ok")
//                alert.show()
                self.stopAllAnimation()
                if status {
                    NSLog("Data test 1")
                    for (key, subJson): (String, JSON) in responseObj!{
                        NSLog("Data test 2")
                        if key == "data"{
                            CoreData.saveAllFeedsLocally(subJson)
                            self.fetchedSetup()
                            self.tbl_Listing.reloadData()
//                            var alert = UIAlertView(title: "test2", message: "", delegate: nil, cancelButtonTitle: "Ok")
//                            alert.show()
                            
                        }
                        NSLog("Data test 3")
                        if key == "moreFeeds"{
                            if subJson.boolValue {
                                self.sendFeedsRequest(animation)
                            }else{
                                if  let _ = self.navigationController as? CommonNavigationViewController {
//                                    nav.setCountValueTolabel()
                                }
                                self.refreshControl.endRefreshing()
                            }
                        }
                    }
                }else{
                    self.refreshControl.endRefreshing()
                    
                }
            }
        }
    }
    func stopAllAnimation(){
        //SVProgressHUD.dismiss()
    }
    //MARK: - Fetched Result Controller Initialisation
    func fetchedSetup(){
        NSFetchedResultsController.deleteCacheWithName("Feed")
        feedsFetchResultController = getFetchedResultController()
        do {
            //        feedsFetchResultController.delegate = self
            try feedsFetchResultController.performFetch()
        } catch _ {
        }
    }
    func getFetchedResultController() -> NSFetchedResultsController {
        feedsFetchResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(), managedObjectContext: CommonFunctions.getAppdelegateObject().managedObjectContext!, sectionNameKeyPath: nil, cacheName:"Feed")
        return feedsFetchResultController
    }
    func taskFetchRequest() -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"createdTime", ascending: false), NSSortDescriptor(key: "feed_Id", ascending: false)]
        fetchRequest.predicate = NSPredicate(format:"socialMediaType == %@",socialType.rawValue)
        fetchRequest.fetchBatchSize = 5
        return fetchRequest
    }

    //MARK: - Fetched results controller delegaes all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tbl_Listing.beginUpdates()
    }
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tbl_Listing.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        case .Update:
            _ = tbl_Listing.cellForRowAtIndexPath(indexPath!)
            tbl_Listing.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
        case .Move:
            tbl_Listing.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
            tbl_Listing.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        case .Delete:
            tbl_Listing.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
/*        default:
            return*/
        }
    }
    /* called last tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tbl_Listing.endUpdates()
    }

    //MARK: - Cell Actions and methods
    func shareBtnTapped(sender : UIButton){
        
        let feedObject = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedClass
        let feedTypeObj : FeedType = FeedType(rawValue:feedObject.feedType)!
        
        let textToShare = feedObject.titleFeed
        let imageURL : NSURL? = NSURL(string:CommonFunctions.getImageNameFromCollection(feedObject.imageFeed, thumbnail:true))
        var linkURL  : NSURL? = NSURL()
        
        switch feedTypeObj{
            
        case FeedType.Video ,FeedType.Upload , FeedType.Youtube:
            _ = SocialType(rawValue: feedObject.socialMediaType)
            let arrVideoes = feedObject.videoFeed.componentsSeparatedByString(",")
            if arrVideoes.count > 0{
                let urlString = arrVideoes.first!
                let url : NSURL! = NSURL(string: urlString)
                linkURL = url
            }
        case FeedType.Photo , FeedType.Image, FeedType.Blog , FeedType.Link:
            linkURL = NSURL(string:feedObject.linkFeed)!
            
//        case FeedType.Youtube:
//            linkURL = NSURL(string:feedObject.videoFeed)!
        default:
            print("do nothing", terminator: "")
        }
        var objectsToShare = [AnyObject]()
        if let _ = imageURL{
            if let _ = linkURL{
                objectsToShare = [textToShare, imageURL!, linkURL!]
            }else{
                objectsToShare = [textToShare, imageURL!]
            }
        }else{
            if let _ = linkURL{
                objectsToShare = [textToShare, linkURL!]
            }else{
                objectsToShare = [textToShare]
            }
        }
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    func favoriteBtnTapped(sender : UIButton){
        let feedObject = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedClass
        CoreData.updateFavoriteOfFeed(feedObject)
        tbl_Listing.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.setFavoritesCount()
        }
        
    }
    //MARK: - Rotation Delegate
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.hideQuickLaunch()
            nav.menuBtnFrameSet(self.view.frame)
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        if(socialType == SocialType.Twitter){
            for var i = 0; i < feedsFetchResultController.fetchedObjects?.count; i++ {
                let feedObj = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! FeedClass
                if(feedObj.isNew){
                    CoreData.updateNewOfFeed(feedObj)
                }
//            }
            
//            for feedObj : AnyObject in feedsFetchResultController.fetchedObjects {
//                if let view = feedObj as? FeedClass {
//                    
//                }
//            }
        }
    }
}
