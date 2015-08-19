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

public class EventController: UIViewController, FriendsControllerDelegate, YelpSearchOptionsDelegate, CLLocationManagerDelegate {
    var loggedInUser = Realm().objects(User).first!
    var invitedFriends = [User]()
    let locationManager = CLLocationManager()
    let yelpClient = YelpClient.sharedInstance
    
    var yelpJSON = JSON([])
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var yelpLocationNameLabel: UILabel!
    @IBOutlet weak var yelpResultAddressButton: UIButton!
    @IBOutlet weak var yelpSearchOption: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public func createEventWithFriends(friends: [User]) {
        for friend in friends {
            friendLabel.text = friendLabel.text! + friend.username + ", "
        }
        invitedFriends = friends
    }
    
    public func setSearchOption(searchOption: String) {
        yelpSearchOption.setTitle(searchOption + " >", forState: UIControlState.Normal)
        yelpClient.setSearchOption(searchOption)
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inviteFriendToEvent" {
            let friendsController = segue.destinationViewController as! FriendsController
            friendsController.delegate = self
        }
        if segue.identifier == "viewSearchOptions" {
            let yelpSearchOptionsController = segue.destinationViewController as! YelpSearchOptionsController
            yelpSearchOptionsController.delegate = self
        }
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
    
    @IBAction func removeKeyboardFromScreen(sender: AnyObject) -> Void {
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) -> Void {
    }
    
    private func invitedFriendsIDs() -> [Int] {
        var idList = [Int]()
        for friend in invitedFriends {
            idList.append(friend.id)
        }
        return idList
    }
}
