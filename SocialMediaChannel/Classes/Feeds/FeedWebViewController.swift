//
//  FeedWebViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 24/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit
import SVProgressHUD

class FeedWebViewController: CommonViewController, UIWebViewDelegate {
    var urlString = String()
    @IBOutlet weak var main_Web: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithNavigationTitle("", leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeNone, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: nil)
        if checkForInternetConnections(){
        main_Web.loadRequest(NSURLRequest(URL: NSURL(string: urlString)!))
        main_Web.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
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

    //MARK: - WebView Delegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
         SVProgressHUD.show()
        return true
    }
    func webViewDidStartLoad(webView: UIWebView){
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(webView: UIWebView){
         SVProgressHUD.dismiss()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
         SVProgressHUD.dismiss()
    }
}
