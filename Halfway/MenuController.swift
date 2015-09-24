//
//  MenuController.swift
//  Halfway
//
//  Created by Kevin Arifin on 8/23/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MenuController: UITableViewController {
    
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var userCell: UITableViewCell!
    @IBOutlet weak var createEventCell: UITableViewCell!
    @IBOutlet weak var manageEventsCell: UITableViewCell!
    @IBOutlet weak var addFriendsCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userCell.textLabel!.text = logged_in_user().username
        logoutCell.textLabel!.text = "Logout"
        createEventCell.textLabel!.text = "Create Event"
        manageEventsCell.textLabel!.text = "My Events"
        addFriendsCell.textLabel!.text = "Add Friends"
        
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell?.textLabel?.text as String! == "Logout"  {
            let realm = try! Realm()
            realm.write {
                realm.deleteAll()
            }
            self.performSegueWithIdentifier("logout", sender: self)
        }
    }
    
    private func logged_in_user() -> User {
        let realm = try! Realm()
        return realm.objects(User).first!
    }
}