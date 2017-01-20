//
//  SettingsViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 20/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class SettingsViewController: CommonViewController , UITableViewDataSource , UITableViewDelegate{

    //MARK: - Varibles and Outlets
    @IBOutlet weak var tbl_Settings: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithNavigationTitle(NSLocalizedString("Settings", comment: ""), leftButtonType:LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeNone , rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: nil)
        self.configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setNavigationHideOnSwipe(false)
        tbl_Settings.reloadData()
        if let nav = self.navigationController as? CommonNavigationViewController{
            nav.menuButtonStatusShow(false)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - TableView Delegate and DataSource
    func configureTableView() {
        tbl_Settings.registerNib(UINib(nibName:"SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        tbl_Settings.registerNib(UINib(nibName:"ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55.0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        var cell : UITableViewCell
        if indexPath.row == 0{
           cell = tableView.dequeueReusableCellWithIdentifier("notificationCell") as! SettingsTableViewCell
            (cell as! SettingsTableViewCell).swtichNotication.addTarget(self, action:"switchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            var flag = false
            if Int((UserDefaultsUtility.getNotificationStatus())!)! == 1{
                flag = true
            }
           (cell as! SettingsTableViewCell).swtichNotication.setOn(flag, animated: true)
        }else{
           cell = tableView.dequeueReusableCellWithIdentifier("listCell") as! ListTableViewCell
            (cell as! ListTableViewCell).setUpCell(self.getStringFromIndex())
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1{
            let list : ListingViewController = ListingViewController(nibName:"ListingViewController", bundle: nil)
            self.navigationController!.pushViewController(list, animated: true)
        }
    }
    
    //MARK: - Actions , Swtich
    func getStringFromIndex()->String{
        let index  = QuickLaunchType(rawValue: UserDefaultsUtility.getFeedsSelectionScreen()!)
        return index!.detailsTab()
    }
    func switchTapped(switchBtn : UISwitch){
        if switchBtn.on{
            CommonFunctions.getAppdelegateObject().updateNotificationFlagWithDeviceToken(UserDefaultsUtility.getDeviceToken()!, flag: "1")
        }else{
            CommonFunctions.getAppdelegateObject().updateNotificationFlagWithDeviceToken(UserDefaultsUtility.getDeviceToken()!, flag: "0")
        }
    }
}
