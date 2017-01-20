//
//  ListingViewController.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 22/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

class ListingViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Varibles and Outlets
    @IBOutlet weak var tbl_Listing: UITableView!
    var selectedIndex = 0
    var listArray = QuickLaunchType.getAllArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonWithNavigationTitle(NSLocalizedString("Default Opening Tab", comment: ""), leftButtonType: LeftButtonTypeEnum.LeftButtonTypeBackNavigationWithOptions, rightButtonType: RightButtonTypeEnum.RightButtonTypeNone, rightText: nil, rightButtonImageRight: nil, rightButtonImageleft: nil)
        self.configureTableView()
        selectedIndex = UserDefaultsUtility.getFeedsSelectionScreen()!
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       if let nav = self.navigationController as? CommonNavigationViewController{
        nav.menuButtonStatusShow(false)
        }
    }

    //MARK: - TableView Delegate and DataSource
    func configureTableView() {
        tbl_Listing.registerNib(UINib(nibName:"SelectionTableViewCell", bundle: nil), forCellReuseIdentifier:"selectionCell")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return listArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 54.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = tableView.dequeueReusableCellWithIdentifier("selectionCell") as! SelectionTableViewCell

        if indexPath.row%2 == 0{
            cell.backgroundColor = CommonFunctions.colorWithRGB(251, g: 251, b: 251, a: 1)
        }else{
            cell.backgroundColor = CommonFunctions.colorWithRGB(242, g: 242, b: 242, a: 1)
        }
        if selectedIndex == indexPath.row{
            cell.setupCell(listArray[indexPath.row], flag:true)
        }else {
            cell.setupCell(listArray[indexPath.row], flag:false)
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row as QuickLaunchType.RawValue
        let oldIndex = selectedIndex
        selectedIndex = index
        UserDefaultsUtility.setFeedsSelectionScreen(index)
        tableView.reloadRowsAtIndexPaths([ NSIndexPath(forRow: oldIndex, inSection: 0), NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
    }

}
