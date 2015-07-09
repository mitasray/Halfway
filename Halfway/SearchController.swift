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
    
    let url = "http://halfway-db.herokuapp.com/v1/users"
    let defaults = NSUserDefaults.standardUserDefaults()
    var userList:[String] = []
    var filteredUsers = [String]()
    let access_token: String = NSUserDefaults.standardUserDefaults().stringForKey("access_token")!
    
    public func listOfAllUsers() {
        request(.GET, self.url, parameters: ["access_token": self.access_token]).responseJSON() {
            (_, _, json, _) in
            println(JSON)
            var json = JSON(json!)
            var numberOfUsers = json.count
            for (var user_index = 0; user_index < numberOfUsers; user_index++) {
                self.addUsername(String(stringInterpolationSegment: json[user_index]["username"]))
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    public func addUsername(username: String) {
        userList.append(username)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        listOfAllUsers()
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredUsers.count
        } else {
            return self.userList.count
        }    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var username: String
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            username = filteredUsers[indexPath.row]
        } else {
            username = userList[indexPath.row]
        }

        cell.textLabel?.text = username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    private func filterUsersForSearchText(searchText: String, scope: String = "All") {
        self.filteredUsers = self.userList.filter({( user: String) -> Bool in
            let categoryMatch = (scope == "All") || (user == scope)
            let stringMatch = user.rangeOfString(searchText)
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
