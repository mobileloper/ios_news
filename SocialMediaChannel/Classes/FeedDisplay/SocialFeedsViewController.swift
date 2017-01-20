//
//  SocialFeedsViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 20/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer

class SocialFeedsViewController: CommonViewController  ,
    UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout ,UISearchControllerDelegate , NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    //MARK: - Varibles and constants
    var isDataFiltered: Bool = false
    var searchedString = String()
    lazy var feedsFetchResultController: NSFetchedResultsController = NSFetchedResultsController()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var origin: NSLayoutConstraint!
    @IBOutlet var collectionView: UICollectionView?
    @IBOutlet var searchBarContainer: UIView?
    var searchController: UISearchController?
    @IBOutlet var searchbar: UISearchBar?
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewCellSetup()
        self.searchControllerSetup()
        self.setUpNavigationBar()
        self.fetchedSetup()
      self.sendFeedsRequest(true)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationAttributes(SocialType.Youtube)
        if  let nav = self.navigationController as? CommonNavigationViewController {
        nav.menuButtonStatusShow(true)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for var i = 0; i < feedsFetchResultController.fetchedObjects?.count; i++ {
            let feedObj = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! FeedClass
            if(feedObj.isNew){
                CoreData.updateNewOfFeed(feedObj)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setUpNavigationBar(){
        var title : String = SocialType.Youtube.rawValue as String
        title = title.capitalizedString
        title = title+"-feeds"
        title = NSLocalizedString(title, comment: "")
        for parent in self.navigationController!.navigationBar.subviews {
            for childView in parent.subviews {
                if(childView is UIImageView) {
                    childView.removeFromSuperview()
                }
            }
        }
//        self.setBackButtonWithNavigationTitle(title, leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeTwoImages, rightText: nil, rightButtonImageRight:"ic-settings" , rightButtonImageleft:"ic-search")
        
        self.setBackButtonWithNavigationTitle(title, leftButtonType: LeftButtonTypeEnum.LeftButtonTypeRevealMenu, rightButtonType: RightButtonTypeEnum.RightButtonTypeOneImage, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: "ic-settings")

    }

    //MARK: - Search Action Methods and Delegate Methods
    func searchControllerSetup(){
        self.searchbar?.searchBarStyle = UISearchBarStyle.Default
        self.searchbar?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.searchbar?.barStyle = UIBarStyle.Default
        self.searchbar?.placeholder = NSLocalizedString("YouTube Search", comment: "")
        self.searchbar?.barTintColor = SocialType.Youtube.color()
        self.searchbar?.delegate = self
        return
            /*
//        searchbar = UISearchBar(frame: <#CGRect#>)
        searchController = ({
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
          
            //setup the search bar
            self.searchbar?.searchBarStyle = UISearchBarStyle.Default
            self.searchbar?.autoresizingMask = UIViewAutoresizing.FlexibleWidth
            self.searchbar?.barStyle = UIBarStyle.Default
            self.searchbar?.placeholder = "YouTube Search"
            self.searchbar?.barTintColor = SocialType.Youtube.color()
            
            self.searchBarContainer?.addSubview(searchController.searchBar)
            searchController.searchBar.sizeToFit()
            UIView.animateWithDuration(2, animations: {
                if self.origin.constant == 0 {
                    self.origin.constant = -44 }
                else{
                    self.origin.constant = 0
                }
                }, completion: { finished in
                    self.view.layoutIfNeeded()
                    self.view.setTranslatesAutoresizingMaskIntoConstraints(true)
            })
            return searchController
        })()*/
    }
    func searchIsEmpty() -> Bool{
        if let searchTerm = self.searchbar?.text {
            return searchTerm.isEmpty
        }
        return true
    }
    func filterData(textToSearch:String){
         NSFetchedResultsController.deleteCacheWithName("Feed")
        if textToSearch.isEmpty {
            searchedString = ""
            isDataFiltered = false
           self.searchbar?.resignFirstResponder()
            feedsFetchResultController = getFetchedResultController()
            self.searchbar?.text = ""
            
        }else{
            searchedString = textToSearch
            isDataFiltered = true

            feedsFetchResultController = getFetchedResultControllerFilter()
           
        }
        do {
            try feedsFetchResultController.performFetch()
        } catch _ {
        }
    }
    //MARK:UISearchResultsUpdating and UIScrollViewDelegate
/*    func updateSearchResultsForSearchController(searchController: UISearchController){
        filterData()
        collectionView?.reloadData()
    }*/
    func scrollViewWillBeginDragging(scrollView: UIScrollView){
        //dismiss the keyboard if the search results are scrolled
        searchController?.searchBar.resignFirstResponder()
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        searchController?.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool{
        let newString = (self.searchbar!.text! as NSString).stringByReplacingCharactersInRange(range, withString: text)

        filterData(newString)
        collectionView?.reloadData()
        return true
    }

    
    //MARK: UICollectionViewDataSource
    func collectionViewCellSetup(){
         collectionView!.registerNib(UINib(nibName:"HeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"headerCell")
//         collectionView!.registerNib(UINib(nibName:"thumbnailFeedsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"thumbCell")
        refreshControl.tintColor = colorTheme()
        refreshControl.addTarget(self, action:"pullToRefresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionView!.addSubview(refreshControl)

    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
          return  feedsFetchResultController.fetchedObjects!.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        // Create a dummy UICollectionViewCell so the compiler doesn't complain
        let cell = UICollectionViewCell()
        let fobj: FeedClass = feedsFetchResultController.objectAtIndexPath(indexPath) as! FeedClass
        
//        if indexPath.row == 0{
            if let labelCell = collectionView.dequeueReusableCellWithReuseIdentifier("headerCell", forIndexPath: indexPath) as? HeaderCollectionViewCell{
                labelCell.shareImage.addTarget(self, action: "shareBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                labelCell.favoriteBtn.addTarget(self, action: "favoriteBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                
                labelCell.setUpCell(indexPath.row , feedObject: fobj)
                return labelCell
            }
//        }else{
//            if let labelCell = collectionView.dequeueReusableCellWithReuseIdentifier("thumbCell", forIndexPath: indexPath) as? thumbnailFeedsCollectionViewCell {
//                labelCell.shareImage.addTarget(self, action: "shareBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
//                labelCell.favoriteBtn.addTarget(self, action: "favoriteBtnTapped:", forControlEvents: UIControlEvents.TouchUpInside)
//                
//                labelCell.setUpCell(indexPath.row, feedObject: fobj)
//                cell = labelCell
//            }
//        }
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
       
        if (self.searchController?.searchBar.isFirstResponder() != nil){
        self.searchController?.searchBar.resignFirstResponder()
        }
        
        let feedObj: FeedClass = feedsFetchResultController.objectAtIndexPath(indexPath) as! FeedClass
        let feedTypeObj : FeedType = FeedType(rawValue:feedObj.feedType)!
        if feedObj.isNew == true {
            CoreData.updateNewOfFeed(feedObj)
        }
        switch feedTypeObj{
            
        case FeedType.Video, FeedType.Upload : // type video and social type instagram thn mp4 file
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
        case FeedType.Youtube, FeedType.Bulletin:
            
            let arrVideoes = feedObj.videoFeed.componentsSeparatedByString(",")
            
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
        default:
            print("do nothing", terminator: "")
        }
    }
    //MARK: UICollectionViewFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//        if indexPath.row == 0{
            return CGSizeMake(collectionView.frame.size.width, 294)
//        }else{
//            return CGSizeMake(collectionView.frame.size.width/2, 240)
//        }
    }
    
    //MARK: - Right Button Action
    override func rightButtonAction(sender : UIButton!){
        if sender.tag == 100{
            if isDataFiltered {
                return
            }
            
            UIView.animateWithDuration(2, animations: {
                if self.origin.constant == 0 {
                    self.origin.constant = -44 }
                else{
                    self.origin.constant = 0
                }
                }, completion: { finished in
                    self.view.layoutIfNeeded()
                    self.view.translatesAutoresizingMaskIntoConstraints = true
            })
        }else{
            let setting : SettingsViewController = SettingsViewController(nibName:"SettingsViewController", bundle: nil)
            self.navigationController!.pushViewController(setting, animated: true)
        }
    }
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
    }
    
    //MARK: - Pull to refresh and Requests
    func sendFeedsRequest(animation : Bool){
        // if previous
        let tuple = CoreData.fetchTopMostFeedWithType(SocialType.Youtube)
        if let val = tuple{
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
        var url = kGetFeedsList+"&direction=previous?social_media_type=youtube"
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
                            self.collectionView!.reloadData()
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
    feedsFetchResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(""), managedObjectContext: CommonFunctions.getAppdelegateObject().managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Feed")
    return feedsFetchResultController
    }
    func getFetchedResultControllerFilter() -> NSFetchedResultsController {
        feedsFetchResultController = NSFetchedResultsController(fetchRequest: taskFetchRequest(searchedString), managedObjectContext: CommonFunctions.getAppdelegateObject().managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Feed")
        return feedsFetchResultController
    }
    func taskFetchRequest(searchString : String) -> NSFetchRequest{
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key:"createdTime", ascending: false), NSSortDescriptor(key: "feed_Id", ascending: false)]
        fetchRequest.fetchBatchSize = 5
        if(searchString.isEmpty){
            fetchRequest.predicate = NSPredicate(format:"socialMediaType == %@","youtube")
        }else{
            fetchRequest.predicate = NSPredicate(format:"socialMediaType == %@ AND titleFeed contains[c] %@",argumentArray :["youtube", searchString])
        }
        return fetchRequest
    }

    //MARK: - Fetched results controller delegaes all updates are animated simultaneously */
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        //tbl_Feeds.beginUpdates()
    }
    /* called:
    - when a new model is created
    - when an existing model is updated
    - when an existing model is deleted */
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?)
    {
        switch type {
        case .Insert:
             collectionView!.insertItemsAtIndexPaths([newIndexPath!])
        case .Update:
            let cell = collectionView!.cellForItemAtIndexPath(indexPath!)
             collectionView!.reloadItemsAtIndexPaths([indexPath!])
        case .Move:
             collectionView!.deleteItemsAtIndexPaths([indexPath!])
             collectionView!.insertItemsAtIndexPaths([newIndexPath!])
        case .Delete:
             collectionView!.deleteItemsAtIndexPaths([indexPath!])
        default:
            return
        }
    }
    /* called last tells `UITableView` updates are complete */
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
       // tbl_Feeds.endUpdates()
    }
    //MARK: - Cell Actions and methods
    func shareBtnTapped(sender : UIButton){
        
        let feedObject = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forItem: sender.tag, inSection: 0)) as! FeedClass
        
        feedsFetchResultController.objectAtIndexPath(NSIndexPath(forItem: sender.tag, inSection: 0)) as! FeedClass
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
          let feedObject = feedsFetchResultController.objectAtIndexPath(NSIndexPath(forItem: sender.tag, inSection: 0)) as! FeedClass
        
        CoreData.updateFavoriteOfFeed(feedObject)
//        collectionView?.reloadData()
        collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: sender.tag, inSection: 0)])

        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.setFavoritesCount()
        }
    }
    //MARK: - Rotation Delegate
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.layoutIfNeeded()
        collectionView?.reloadData()
        if  let nav = self.navigationController as? CommonNavigationViewController {
            nav.hideQuickLaunch()
            nav.menuBtnFrameSet(self.view.frame)
        }
    }
}
