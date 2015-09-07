//
//  AddFriendsController.swift
//  Halfway
//
//  Created by Kevin Arifin on 9/6/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Alamofire

class AddFriendsController: UITableViewController, UISearchResultsUpdating  {
    
    var resultSearchController = UISearchController()
    var all_users = Realm().objects(User)
    var user_friends = Realm().objects(User).first!.friends
    var filtered_users = [User]()
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.active {
             return filtered_users.count
        } else {
            return user_friends.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filtered_users[indexPath.row].username
            return cell
        } else {
            cell.textLabel?.text = self.user_friends[indexPath.row].username
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.resultSearchController.active {
            var selectedUser = self.filtered_users[indexPath.row]
            let add_friend_url = "http://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user().id) + "/friendships"
            let parameters = [
            "friend_id": selectedUser.id
            ]
            let realm = Realm()
            request(.POST, add_friend_url, parameters: parameters).validate().responseJSON { (request, response, json, error) in
                var friend_attributes = json as! Dictionary<String, AnyObject>
                var username = friend_attributes["username"]! as! String
                let predicate = NSPredicate(format: "username = %@", username)
                var added_user = realm.objects(User).filter(predicate).first!
            
                Realm().write {
                    self.logged_in_user().friends.append(added_user)
                }
            }
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filtered_users.removeAll(keepCapacity: false)
        let predicate = NSPredicate(format: "username = %@", searchController.searchBar.text!)
        var filteredUserResults = Realm().objects(User).filter(predicate)
        
        let array = (map(filteredUserResults){ $0 } as NSArray)
        
        self.filtered_users = array as! [User]
        
        self.tableView.reloadData()
    }
    
    private func logged_in_user() -> User {
        let realm = Realm()
        return realm.objects(User).first!
    }
}
