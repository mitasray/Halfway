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

public class SearchController: UITableViewController {
    
    let url = "http://halfway-db.herokuapp.com/v1/users"
    let defaults = NSUserDefaults.standardUserDefaults()
    var userList:[String] = []
    
    public func listOfAllUsers() {
        request(.GET, self.url).responseJSON { (_, _, json, _) in
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
        return userList.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var username = userList[indexPath.row]
        cell.textLabel?.text = username
        return cell
    }
}
