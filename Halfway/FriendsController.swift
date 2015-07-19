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

protocol FriendsControllerDelegate {
    func createEventWithFriend(friend: User)
}

public class FriendsController: UITableViewController {
    var delegate: FriendsControllerDelegate? = nil
    let defaults = NSUserDefaults.standardUserDefaults()
    let user_id = NSUserDefaults.standardUserDefaults().stringForKey("user_id")
    var friendList = [User]()
    let users_url = "http://halfway-db.herokuapp.com/v1/users/"
    
    public func listOfAllFriends() {
        let url = self.users_url + self.user_id! + "/friendships"
        request(.GET, url).responseJSON() {
            (_, _, json, _) in
            var json = JSON(json!)
            var numberOfUsers = json.count
            for (var user_index = 0; user_index < numberOfUsers; user_index++) {
                var username = String(stringInterpolationSegment: json[user_index]["username"])
                var user_id: Int? = String(stringInterpolationSegment: json[user_index]["id"]).toInt()
                
                var friend: User = User(username: username, user_id: user_id!)
                self.addFriendToFriendList(friend)
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
    
    public func addFriendToFriendList(user: User) {
        friendList.append(user)
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var friend_username: String
        
        friend_username = friendList[indexPath.row].username
        
        cell.textLabel?.text = friend_username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        
        var friend = self.friendList[indexPath.row]
        if delegate != nil {
            delegate?.createEventWithFriend(friend)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}