//
//  SortScreenView.swift
//  SocialMediaChannel
//
//  Created by Mohit Jethwa on 24/07/15.
//  Copyright (c) 2015 Mohit Jethwa. All rights reserved.
//

import UIKit

protocol SortDelegate{
   
    func sortOptionSelected(index : SortOptionType)
    func hideSortView()
}
class SortScreenView: UIView , UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var tbl_Feeds: UITableView!
    @IBOutlet weak var transparentColor: UIImageView!
    @IBOutlet weak var sortByLabel: UILabel!
    var feedsArray = SortOptionType.getAllArray()
    var selectedType = SortOptionType.Date
    var delegate: SortDelegate?
    
    func initialSetUp(){
        configureTableView()
    }
    //MARK: - TableView Delegate and DataSource
    func configureTableView() {
        tbl_Feeds.registerNib(UINib(nibName:"SortTableViewCell", bundle: nil), forCellReuseIdentifier: "sortCell")
        tbl_Feeds.rowHeight = UITableViewAutomaticDimension
        tbl_Feeds.estimatedRowHeight = 25.0
        sortByLabel.text = NSLocalizedString("Sort By", comment: "")
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        let cell = tableView.dequeueReusableCellWithIdentifier("sortCell") as! SortTableViewCell
        cell.setUpCell(feedsArray[indexPath.row], isSelected: selectedType.rawValue == indexPath.row ? true:false)
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
       selectedType = SortOptionType(rawValue:indexPath.row)!
       tbl_Feeds.reloadData()
       delegate?.sortOptionSelected(selectedType)
    }
    //Tap Gesture Actions
    @IBAction func Tapped(sender: AnyObject) {
     delegate?.hideSortView()
    }
}
