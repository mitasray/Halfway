//
//  EventManagerController.swift
//  Halfway
//
//  Created by Kevin Arifin on 8/24/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SWRevealViewController

class EventManagerController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    func listOfAllEvents() -> List<Event> {
        return logged_in_user().events
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var event = listOfAllEvents()[indexPath.row].details
        
        cell.textLabel?.text = event
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAllEvents().count
    }
    
    private func logged_in_user() -> User {
        return Realm().objects(User).first!
    }
}
