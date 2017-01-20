//
//  FeedsViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 16/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

import CoreData
import MediaPlayer

class FeedsViewController: CommonViewController , UITableViewDelegate , UITableViewDataSource , NSLayoutManagerDelegate , NSFetchedResultsControllerDelegate{
   // MARK: -  Varibles and outlets
    @IBOutlet weak var tbl_Feeds: UITableView!
    var refreshControl = UIRefreshControl()
    //MARK: - FetchedResultController Setup
    var feedsFetchResultController: NSFetchedResultsController  {
        get {
            if(self._feedsFetchResultController == nil) {
                NSFetchedResultsController.deleteCacheWithName("Feed")
                let fetchRequest = NSFetchRequest(entityName:"Feed")
                fetchRequest.sortDescriptors = [NSSortDescriptor(key:"createdTime", ascending: false), NSSortDescriptor(key: "feed_Id", ascending: false)]
                let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                    managedObjectContext: CommonFunctions.getAppdelegateObject().managedObjectContext!,
                    sectionNameKeyPath: nil ,
                    cacheName:"Feed")
                
                fetchRequest.fetchBatchSize = 5
                do {
                    try controller.performFetch()
                } catch _ {
                }
                self._feedsFetchResultController = controller
                //        controller.delegate = self
                return controller
            }
            return self._feedsFetchResultController!
        }
    }
    var _feedsFetchResultController:NSFetchedResultsController?
    // MARK: - Class life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.setBackButtonWithNavigationTitle(NSLocalizedString("All Feeds", comment: ""), leftButtonType: LeftButtonTypeEnum.LeftButtonTypeRevealMenu, rightButtonType: RightButtonTypeEnum.RightButtonTypeOneImage, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: "ic-settings")
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSLog("1 \n")
        self.sendFeedsRequest(true)
        //update visible cells for changes in favorite
        NSLog("2 \n")
        let paths:Array? = tbl_Feeds.indexPathsForVisibleRows
        NSLog("3 \n")
        if (paths != nil){
            tbl_Feeds.reloadRowsAtIndexPaths(paths!, withRowAnimation: UITableViewRowAnimation.None)
            NSLog("4 \n")
        }
//        self.shyNavBarManager.scrollView = self.tbl_Feeds
        if let nav = self.navigationController as? CommonNavigationViewController{
            nav.menuButtonStatusShow(true)
            nav.setMainMenuCountValueTolabel()
            NSLog("5 \n")
        }
    }
    // MARK: - Quick Launch Methods
    @IBAction func menuBtnTapped(sender: UIButton) {
        
    }
    //MARK: - Right Button Action
    override func rightButtonAction(sender : UIButton!){
        let setting : SettingsViewController = SettingsViewController(nibName:"SettingsViewController", bundle: nil)
        self.navigationController!.pushViewController(setting, animated: true)
    }
    //MARK: - TableView Delegate and DataSource
     func configureTableView() {
        tbl_Feeds.registerNib(UINib(nibName:"MainFeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "mainFeedCell")
        tbl_Feeds.registerNib(UINib(nibName:"MainTextFeedTableViewCell", bundle: nil), forCellReuseIdentifier:"mainTextCell")
        tbl_Feeds.rowHeight = UITableViewAutomaticDimension
        tbl_Feeds.estimatedRowHeight = 260.0
        refreshControl.tintColor = colorTheme()
        refreshControl.addTarget(self, action:"pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tbl_Feeds.addSubview(refreshControl)
     }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsFetchResultController.fetchedObjects!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        
        let feedObj: FeedClass = feedsFetchResultController.objectAtIndexPath(indexPath) as! FeedClass
        let feedTypeObj = FeedType(rawValue:feedObj.feedType)
        if feedTypeObj == FeedType.Text || feedTypeObj  == FeedType.Status {
            let cell = tableView.dequeueReusableCellWithIdentifier("mainTextCell") as! MainTextFeedTableViewCell
            cell.shareBtn.addTarget(self, action: "shareBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.favoriteBtn.addTarget(self, action: "favoriteBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)

            cell.setUpCell(indexPath.row , feedObject: feedObj)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("mainFeedCell") as! MainFeedsTableViewCell
            cell.shareBtn.addTarget(self, action: "shareBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.favoriteBtn.addTarget(self, action: "favoriteBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            cell.setUpCell(indexPath.row, feedObject: feedObj, feedType: feedTypeObj!)
            return cell
        }
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
                
/*                let feedVideo : FeedVideoViewController  = FeedVideoViewController(nibName:"FeedVideoViewController", bundle: nil)
                var arrVideoID = feedObj.videoFeed.componentsSeparatedByString("watch?v=")
                if arrVideoID.count == 2{
                    feedVideo.videoID = arrVideoID.last!
                    self.navigationController!.pushViewController(feedVideo, animated: true)
*/

                let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
                
                if arrVideoes.count > 0{
                    feedWeb.urlString = arrVideoes.first!
                    self.navigationController!.pushViewController(feedWeb, animated: true)
                }
                else{
                    let feedVideo : FeedVideoViewController  = FeedVideoViewController(nibName:"FeedVideoViewController", bundle: nil)
                    let arrVideoID = feedObj.videoFeed.componentsSeparatedByString("watch?v=")
                    if arrVideoID.count == 2{
                        feedVideo.videoID = arrVideoID.last!
                        self.navigationController!.pushViewController(feedVideo, animated: true)
                    }
                }
            }else{
                let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
                if arrVideoes.count > 0{
                    feedWeb.urlString = arrVideoes.first!
                    self.navigationController!.pushViewController(feedWeb, animated: true)
                }
            }
        case FeedType.Photo , FeedType.Image:
            let socialType = SocialType(rawValue: feedObj.socialMediaType)
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
            let feedWeb : FeedWebViewController  = FeedWebViewController(nibName:"FeedWebViewController", bundle: nil)
            let arrVideoes = feedObj.videoFeed.componentsSeparatedByString(",")
            if arrVideoes.count > 0{
                feedWeb.urlString = arrVideoes.first!
                self.navigationController!.pushViewController(feedWeb, animated: true)
            }
            else{
                let feedVideo : FeedVideoViewController  = FeedVideoViewController(nibName:"FeedVideoViewController", bundle: nil)
                let arrVideoID = feedObj.videoFeed.componentsSeparatedByString("watch?v=")
                if arrVideoID.count == 2{
                    feedVideo.videoID = arrVideoID.last!
                    self.navigationController!.pushViewController(feedVideo, animated: true)
                }
            }
        default:
            print("do nothing", terminator: "")
        }
    }
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    }
    //MARK: - Requests, Pull to refresh and Infinite Scroll
    func sendFeedsRequest(animation : Bool){
        // if previous
        let tuple = CoreData.fetchTopMostFeedWithType(SocialType.All)
        if let val = tuple{
            self.sendFeedsRequestUpdated(animation, time: tuple!.0)
        }
//        let tuple1 = CoreData.fetchBottomMostFeedWithType(SocialType.All)
//        if let val = tuple1{
//            self.sendFeedsRequestNext(animation, time: tuple1!)
//        }else{
//            self.sendFeedsRequestNext(animation, time: "")
//        }
    }
    func pullToRefresh(){
         sendFeedsRequest(false)
    }
    
    //MARK : Http Requests
    func sendFeedsRequestNext(animation : Bool , time : String){ // Infinite Scroll Request
       
        var url = kGetFeedsList+"&direction=next"
        if !time.isEmpty {
            url = url + "&in_time=\(time)"
        }
        NetworkClass.responseWithUrl(url, parameter: nil, requestType:RequestType.GET, tagString:"Feeds") { (status, responseObj, error, statusCode, tag) in
            dispatch_async(dispatch_get_main_queue()) {
                self.stopAllAnimation()
                if status {
                    for (key, subJson): (String, JSON) in responseObj!{
                        if key == "data"{
                            CoreData.saveAllFeedsLocally(subJson)
                        }
                        if key == "moreFeeds"{
                            let tuple1 = CoreData.fetchBottomMostFeedWithType(SocialType.All)
                            if let val = tuple1{
                                self.sendFeedsRequestNext(animation, time: tuple1!)
                            }
                        }
                    }
                }else{
                    self.refreshControl.endRefreshing()

                }
            }
    
        }
    }
    func sendFeedsRequestUpdated(animation : Bool , time : Int32){ // PullToRefresh Request
        if animation {
            // SVProgressHUD.show()
        }
        var url = kGetFeedsList+"&direction=previous"
        if time != 0 {
            url = url + "&id=\(time)"
        }
        NetworkClass.responseWithUrl(url, parameter: nil, requestType:RequestType.GET, tagString:"Feeds") { (status, responseObj, error, statusCode, tag) in
            dispatch_async(dispatch_get_main_queue()) {
                self.stopAllAnimation()
                if status {
                    for (key, subJson): (String, JSON) in responseObj!{
                        if key == "data"{
                            CoreData.saveAllFeedsLocally(subJson)
                            self._feedsFetchResultController = nil
                            self.tbl_Feeds.reloadData()
                        }
                        if key == "moreFeeds"{
                            if subJson.boolValue {
                                self.sendFeedsRequest(animation)
                            }else{
                                if  let nav = self.navigationController as? CommonNavigationViewController {
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
      //  SVProgressHUD.dismiss()
       // tbl_Feeds.infiniteScrollingView.stopAnimating()
    }
    //MARK: - Fetched results controller delegaes all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tbl_Feeds.beginUpdates()
    }
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
{
        switch type {
        case .Insert:
            tbl_Feeds.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        case .Update:
            let cell = tbl_Feeds.cellForRowAtIndexPath(indexPath!)
            tbl_Feeds.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
        case .Move:
            tbl_Feeds.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
            tbl_Feeds.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.None)
        case .Delete:
            tbl_Feeds.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        default:
            return
        }
    }
     /* called last tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tbl_Feeds.endUpdates()
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
            let socialType = SocialType(rawValue: feedObject.socialMediaType)
            let arrVideoes = feedObject.videoFeed.componentsSeparatedByString(",")
            if arrVideoes.count > 0{
                let urlString = arrVideoes.first!
                let url : NSURL! = NSURL(string: urlString)
                linkURL = url
            }
         case FeedType.Photo , FeedType.Image, FeedType.Blog , FeedType.Link:
              linkURL = NSURL(string:feedObject.linkFeed)!
        
        case FeedType.Youtube:
            linkURL = NSURL(string:feedObject.videoFeed)!
        default:
            print("do nothing", terminator: "")
        }
        var objectsToShare = [AnyObject]()
        if let image = imageURL{
            if let link = linkURL{
         objectsToShare = [textToShare, imageURL!, linkURL!]
            }else{
         objectsToShare = [textToShare, imageURL!]
            }
        }else{
            if let link = linkURL{
                objectsToShare = [textToShare, linkURL!]
            }else{
                objectsToShare = [textToShare]
            }
        }
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    func favoriteBtnTapped(sender : UIButton){
        NSLog("test 1")
        let feedObject = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forRow: sender.tag, inSection: 0)) as! FeedClass
        NSLog("test 2")
        CoreData.updateFavoriteOfFeed(feedObject)
        NSLog("test 3")
//        tbl_Feeds.reloadData()
        tbl_Feeds.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.setFavoritesCount()
        }
        NSLog("test 4")
    }
    //MARK: - Rotation Delegate
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.hideQuickLaunch()
            nav.menuBtnFrameSet(self.view.frame)
        }
    }
}
