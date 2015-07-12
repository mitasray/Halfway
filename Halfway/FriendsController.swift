//
//  FriendsController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/9/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public class FriendsController: UITableViewController {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let user_id = NSUserDefaults.standardUserDefaults().stringForKey("user_id")
    var friendList = [String]()
    let users_url = "http://halfway-db.herokuapp.com/v1/users/"
    
    public func listOfAllFriends() {
        println(self.user_id)
        let url = self.users_url + self.user_id! + "/friendships"
        println(url)
        request(.GET, url).responseJSON() {
            (_, _, json, _) in
            var json = JSON(json!)
            println(json)
            var numberOfUsers = json.count
            for (var user_index = 0; user_index < numberOfUsers; user_index++) {
                self.addFriendToFriendList(String(stringInterpolationSegment: json[user_index]["username"]))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        listOfAllFriends()
    }
    
    public func addFriendToFriendList(username: String) {
        friendList.append(username)
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var friend_username: String
        
        friend_username = friendList[indexPath.row]
        
        cell.textLabel?.text = friend_username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}