//
//  SearchController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/7/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public class SearchController: UITableViewController, UISearchBarDelegate, UISearchDisplayDelegate {
    
    let users_url = "http://halfway-db.herokuapp.com/v1/users/"
    let defaults = NSUserDefaults.standardUserDefaults()
    var userList:[User] = []
    var filteredUsers = [User]()
    let access_token: String = NSUserDefaults.standardUserDefaults().stringForKey("access_token")!
    let user_id: String = NSUserDefaults.standardUserDefaults().stringForKey("user_id")!
    
    public func listOfAllUsers() {
        request(.GET, self.users_url, parameters: ["access_token": self.access_token]).responseJSON() {
            (_, _, json, _) in
            var json = JSON(json!)
            var numberOfUsers = json.count
            for (var user_index = 0; user_index < numberOfUsers; user_index++) {
                var username = String(stringInterpolationSegment: json[user_index]["username"])
                var user_id: Int? = String(stringInterpolationSegment: json[user_index]["id"]).toInt()
                
                var user: User = User(username: username, user_id: user_id!)
                self.addUser(user)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    public func addUser(user: User) {
        userList.append(user)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        listOfAllUsers()
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var friend = self.userList[indexPath.row]
        request(.POST, self.users_url + "\(friend.user_id)/friendships", parameters: ["friend_id": self.user_id])
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredUsers.count
        } else {
            return self.userList.count
        }
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var username: String
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            username = filteredUsers[indexPath.row].username
        } else {
            username = userList[indexPath.row].username
        }

        cell.textLabel?.text = username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    private func filterUsersForSearchText(searchText: String, scope: String = "All") {
        self.filteredUsers = self.userList.filter({( user: User) -> Bool in
            let categoryMatch = (scope == "All") || (user.username == scope)
            let stringMatch = user.username.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    public func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterUsersForSearchText(searchString)
        return true
    }
    
    public func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterUsersForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
}
