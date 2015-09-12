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

class EventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FriendsControllerDelegate, CLLocationManagerDelegate {
    var loggedInUser = Realm().objects(User).first!
    var invitedFriends = [User]()
    let locationManager = CLLocationManager()
    var typePickerData = [String]()
    var yelpSearchOption = "Food"
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inviteFriendsToEvent" {
            let friendsController = segue.destinationViewController as! FriendsController
            friendsController.delegate = self
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
        
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        
        typePickerData = yelpSearchOptions()
        typePicker.selectRow(3, inComponent: 0, animated: true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        yelpSearchOption = typePickerData[row]
        return typePickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yelpSearchOption = typePickerData[row]
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
    
    @IBAction func createEvent(sender: AnyObject) -> Void {
        let event_url = "http://halfway-db.herokuapp.com/v1/users/" + String(loggedInUser.id) + "/events"
        let realm = Realm()
        realm.write {
            self.logged_in_user().latitude = self.locationManager.location.coordinate.latitude
        }
        
        realm.write {
            self.logged_in_user().longitude = self.locationManager.location.coordinate.longitude
        }
        updateUserLocation()
        let parameters = [
            "date": datePicker.date,
            "description": "event",
            "users": invitedFriendsIDs(),
            "search_param": self.yelpSearchOption
        ]
        request(.POST, event_url, parameters: parameters).validate().responseJSON { (request, response, json, error) in
            println(json)
            var event_details = json as! Dictionary<String, AnyObject>
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            event_details["date"] = dateFormatter.dateFromString(String(stringInterpolationSegment: event_details["date"]))
            event_details["details"] = event_details["description"]
            let created_event = Event(value: event_details)
            realm.write {
                self.logged_in_user().events.append(created_event)
            }
        }
    }
    
    func updateUserLocation() {
        let update_user_url = "http://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user().id)
        let parameters = [
            "user": [
                "latitude": logged_in_user().latitude,
                "longitude": logged_in_user().longitude
            ]
        ]
        request(.PATCH, update_user_url, parameters: parameters)
    }
    
    @IBAction func logOut(sender: AnyObject) -> Void {
        let realm = Realm()
        realm.write {
            realm.deleteAll()
        }
    }
    
    private func logged_in_user() -> User {
        let realm = Realm()
        return realm.objects(User).first!
    }
    
    private func invitedFriendsIDs() -> [Int] {
        var idList = [Int]()
        for friend in invitedFriends {
            idList.append(friend.id) 
        }
        return idList
    }
    
    private func yelpSearchOptions() -> [String] {
        return [
            "Bar",
            "Chinese",
            "Coffee",
            "Food",
            "Indian",
            "Japanese",
            "Korean",
            "Mall",
            "Movie",
            "Park",
            "Restaurant",
            "Vietnamese"
        ]
    }
}
