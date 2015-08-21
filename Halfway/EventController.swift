//
//  EventController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/17/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire
import RealmSwift
import SWRevealViewController

class EventController: UIViewController, FriendsControllerDelegate, YelpSearchOptionsDelegate, CLLocationManagerDelegate {
    var loggedInUser = Realm().objects(User).first!
    var invitedFriends = [User]()
    let locationManager = CLLocationManager()
    let yelpClient = YelpClient.sharedInstance
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var yelpLocationNameLabel: UILabel!
    @IBOutlet weak var yelpResultAddressButton: UIButton!
    @IBOutlet weak var yelpSearchOption: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inviteFriendsToEvent" {
            let friendsController = segue.destinationViewController as! FriendsController
            friendsController.delegate = self
        }
        if segue.identifier == "viewSearchOptions" {
            let yelpSearchOptionsController = segue.destinationViewController as! YelpSearchOptionsController
            yelpSearchOptionsController.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        view.addGestureRecognizer(leftSwipe)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            self.performSegueWithIdentifier("inviteFriendsToEvent", sender: self)
        }
    }
    
    func createEventWithFriends(friends: [User]) {
        for friend in friends {
            friendLabel.text = friendLabel.text! + friend.username + ", "
        }
        invitedFriends = friends
    }
    
    func setSearchOption(searchOption: String) {
        yelpSearchOption.setTitle(searchOption + " >", forState: UIControlState.Normal)
        yelpClient.setSearchOption(searchOption)
    }
    
    @IBAction func createEvent(sender: AnyObject) -> Void {
        let event_url = "http://halfway-db.herokuapp.com/v1/users/" + String(loggedInUser.id) + "/events"
        
        let parameters = [
            "date": datePicker.date,
            "description": "event",
            "users": invitedFriendsIDs()
        ]
        request(.POST, event_url, parameters: parameters).validate().responseJSON { (request, response, json, error) in
            println(json)
        }
    }
    
    @IBAction func logOut(sender: AnyObject) -> Void {
        let realm = Realm()
        realm.write {
            realm.deleteAll()
        }
    }
    
    private func invitedFriendsIDs() -> [Int] {
        var idList = [Int]()
        for friend in invitedFriends {
            idList.append(friend.id)
        }
        return idList
    }
}
