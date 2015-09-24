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
    var selectedEvent = Event()
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "selectEvent" {
            var eventDetailsController = segue.destinationViewController as! EventDetailsController
            eventDetailsController.event = selectedEvent
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        selectedEvent = self.listOfAllEvents()[indexPath.row]
        
        self.performSegueWithIdentifier("selectEvent", sender: self)
    }
    
    private func logged_in_user() -> User {
        let realm = try! Realm()
        return realm.objects(User).first!
    }
}
