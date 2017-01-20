//
//  FavoritesViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 22/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer



class FavoritesViewController: CommonViewController , UITableViewDelegate , UITableViewDataSource , NSFetchedResultsControllerDelegate , SortDelegate {
    // MARK: -  Varibles and outlets
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var tbl_Feeds: UITableView!
    var sortview = SortScreenView()
    var isSortShowing = false
    var sortSelection = SortOptionType.Date
    lazy var feedsFetchResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setBackButtonWithNavigationTitle(NSLocalizedString("Favorites", comment: "") , leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeOneImage, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft:"ic-Sort")
        loadSortScreen()
        fetchedSetup()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController as? CommonNavigationViewController {
            nav.menuButtonStatusShow(true)
        }
        sortview.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
        noDataLabel.text = NSLocalizedString("No Favorties feeds founds", comment: "")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let nav = self.navigationController as? CommonNavigationViewController {
            nav.setFavoritesCount()
        }
        
    }
    //MARK: - Right Button Action
    override func rightButtonAction(sender : UIButton!){
        if isSortShowing{
            self.sortview.transparentColor.backgroundColor = UIColor.clearColor()
            UIView.animateWithDuration(0.5, animations: {
                self.sortview.frame = CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: { finished in
                
            })
        }else{
            self.sortview.transparentColor.backgroundColor = UIColor.clearColor()
            UIView.animateWithDuration(0.5, animations: {
                 self.sortview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                }, completion: { finished in
                    self.sortview.transparentColor.backgroundColor = UIColor.blackColor()
            })
        }
        isSortShowing = !isSortShowing
    }
    //MARK: - TableView Delegate and DataSource
    func loadSortScreen(){
      sortview  = NSBundle.mainBundle().loadNibNamed("SortScreenView", owner: nil, options: nil)[0] as! SortScreenView
      sortview.initialSetUp()
      sortview.delegate = self // Sort Delegate
      self.view.addSubview(sortview)
    }
    func configureTableView() {
        tbl_Feeds.registerNib(UINib(nibName:"MainFeedsTableViewCell", bundle: nil), forCellReuseIdentifier: "mainFeedCell")
        tbl_Feeds.registerNib(UINib(nibName:"MainTextFeedTableViewCell", bundle: nil), forCellReuseIdentifier:"mainTextCell")
        tbl_Feeds.rowHeight = UITableViewAutomaticDimension
        tbl_Feeds.estimatedRowHeight = 260.0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if feedsFetchResultController.fetchedObjects!.count == 0 {
            noDataView.hidden = false
        }else{
            noDataView.hidden = true
        }
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
                let feedVideo : FeedVideoViewController  = FeedVideoViewController(nibName:"FeedVideoViewController", bundle: nil)
                let arrVideoID = feedObj.videoFeed.componentsSeparatedByString("watch?v=")
                if arrVideoID.count == 2{
                    feedVideo.videoID = arrVideoID.last!
                    self.navigationController!.pushViewController(feedVideo, animated: true)
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
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    }
    
    //MARK: - Fetched Result Controller Initialisation
    func fetchedSetup(){
        NSFetchedResultsController.deleteCacheWithName("Feed")
        feedsFetchResultController = getFetchedResultController()
        feedsFetchResultController.delegate = self
        do {
            try feedsFetchResultController.performFetch()
        } catch _ {
        }
    }
    func getFetchedResultController() -> NSFetchedResultsController {
        let tuple = getStringFromSortOption(sortSelection)
        feedsFetchResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(tuple.0 , flag: tuple.1), managedObjectContext: CommonFunctions.getAppdelegateObject().managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Feed")
        feedsFetchResultController.delegate = self
        return feedsFetchResultController
    }
    // createdTime socialMediaType titleFeed
    func getStringFromSortOption(type : SortOptionType)->(String , Bool){
        var returnString = ""
        var flag = false
        switch type{
        case .Date:
            returnString = "createdTime"
            flag = false
        case .Name:
            returnString = "titleFeed"
            flag = true
        case .Channel:
            returnString = "socialMediaType"
            flag = true
        default:
            returnString = "createdTime"
            flag = false
        }
        return  (returnString , flag)
    }
    func taskFetchRequest(str : String , flag : Bool) -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"\(str)", ascending: flag), NSSortDescriptor(key: "feed_Id", ascending: false)]
        fetchRequest.predicate = NSPredicate(format:"isFavorite == true")
        fetchRequest.fetchBatchSize = 5
        return fetchRequest
    }
    
    //MARK: - Fetched results controller delegaes all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tbl_Feeds.beginUpdates()
    }
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tbl_Feeds.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            _ = tbl_Feeds.cellForRowAtIndexPath(indexPath!)
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
            _ = SocialType(rawValue: feedObject.socialMediaType)
            let arrVideoes = feedObject.videoFeed.componentsSeparatedByString(",")
            if arrVideoes.count > 0{
                let urlString = arrVideoes.first!
                let url : NSURL! = NSURL(string: urlString)
                linkURL = url
            }
        case FeedType.Photo , FeedType.Image, FeedType.Blog , FeedType.Link:
            linkURL = NSURL(string:feedObject.linkFeed)!
            
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
        tbl_Feeds.reloadData()
//        tbl_Feeds.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)

        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.setFavoritesCount()
        }
    }
    //MARK: - Sort Delegate
    func sortOptionSelected(index : SortOptionType){
        sortSelection  = index
        feedsFetchResultController = getFetchedResultController()
        do {
            try feedsFetchResultController.performFetch()
        } catch _ {
        }
        tbl_Feeds.reloadData()
        hideSortView()
    }
    func hideSortView(){
      rightButtonAction(nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for var i = 0; i < feedsFetchResultController.fetchedObjects?.count; i++ {
            let feedObj = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! FeedClass
            if(feedObj.isFavoriteNew){
                CoreData.updateNewFavoriteOfFeed(feedObj)
            }
        }
    }
}
