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
    let users_url = "http://halfway-db.herokuapp.com/v1/users/"
    let defaults = NSUserDefaults.standardUserDefaults()
    var friendsList = [User]()
    var usersList = [User]()
    var filteredUsersList = [User]()

  
    
    public func listOfAllUsers() {
        request(.GET, self.users_url, parameters: ["user_id": user_id()]).responseJSON() {
            (_, _, json, _) in
            var json = JSON(json!)
            var numberOfUsers = json.count
            for (var user_index = 0; user_index < numberOfUsers; user_index++) {
                var username = String(stringInterpolationSegment: json[user_index]["username"])
                var user_id: Int? = String(stringInterpolationSegment: json[user_index]["id"]).toInt()
                var user: User = User()
                self.addUserToUsersList(user)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    public func addUserToUsersList(user: User) {
        usersList.append(user)
    }
    
    public func listOfAllFriends() {
        let url = self.users_url + self.user_id() + "/friendships"
        println(url)
        request(.GET, url).responseJSON() {
            (_, _, json, _) in
            var json = JSON(json!)
            var numberOfUsers = json.count
            for (var user_index = 0; user_index < numberOfUsers; user_index++) {
                var username = String(stringInterpolationSegment: json[user_index]["username"])
                var user_id: Int? = String(stringInterpolationSegment: json[user_index]["id"]).toInt()
                
                var friend: User = User()
                self.addFriendToFriendsList(friend)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    public func addFriendToFriendsList(user: User) {
        friendsList.append(user)
    }
    
    public override func viewDidLoad() {
        listOfAllFriends()
        listOfAllUsers()
        super.viewDidLoad()
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredUsersList.count
        } else {
            return friendsList.count
        }
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var friend_username: String = "no users"
        
        if tableView == self.searchDisplayController!.searchResultsTableView && filteredUsersList.count > 0 {
            friend_username = filteredUsersList[indexPath.row].username
        } else if usersList.count > 0 {
            friend_username = usersList[indexPath.row].username
        }
        cell.textLabel?.text = friend_username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        var friend = self.friendsList[indexPath.row]
        if delegate != nil {
            delegate?.createEventWithFriend(friend)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    public func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterUsersForSearchText(searchString)
        return true
    }
    
    public func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterUsersForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    private func filterUsersForSearchText(searchText: String, scope: String = "All") {
        self.filteredUsersList = self.usersList.filter({( user: User) -> Bool in
            let categoryMatch = (scope == "All") || (user.username == scope)
            let stringMatch = user.username.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    private func user_id() -> String {
        return defaults.stringForKey("user_id")!
    }
}