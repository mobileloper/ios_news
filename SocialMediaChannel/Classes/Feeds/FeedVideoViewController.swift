//
//  FeedVideoViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 24/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class FeedVideoViewController: CommonViewController, YTPlayerViewDelegate {
    var videoID = String() // "M7lc1UVf-VE"
    @IBOutlet weak var playerView: YTPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithNavigationTitle("", leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeNone, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: nil)
        if checkForInternetConnections(){
            
        self.setUpAndPlay()
        }
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        playerView.stopVideo()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = self.navigationController as? CommonNavigationViewController{
        nav.menuButtonStatusShow(false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - YTP Player Delegate
    func setUpAndPlay(){
        playerView.delegate = self
        playerView.loadWithVideoId(videoID, playerVars:["controls":1,"playsinline":1,"autohide":1,"showinfo":1,"modestbranding":1])
        print(playerView.availableQualityLevels())
        print(playerView.playbackQuality())
    }
    func playerView(playerView: YTPlayerView!, didChangeToQuality quality: YTPlaybackQuality) {
        
    }
    func playerView(playerView: YTPlayerView!, didChangeToState state: YTPlayerState) {
        
    }
    func playerView(playerView: YTPlayerView!, didPlayTime playTime: Float) {
        print(playerView.availableQualityLevels())
        print(playerView.playbackQuality())

    }
    func playerView(playerView: YTPlayerView!, receivedError error: YTPlayerError) {
        
    }
    func playerViewDidBecomeReady(playerView: YTPlayerView!) {
        print(playerView.availableQualityLevels())
        print(playerView.playbackQuality())
    }

}
