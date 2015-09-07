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
            return self.filtered_users.count
        } else {
            return self.all_users.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filtered_users[indexPath.row].username
            return cell
        }
        else {
            cell.textLabel?.text = self.all_users[indexPath.row].username
            return cell
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
}
