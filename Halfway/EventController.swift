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
import Alamofire
import RealmSwift
import SWRevealViewController
import SVProgressHUD

class EventController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, CLLocationManagerDelegate, UITableViewDelegate {
    var loggedInUser = try! Realm().objects(User).first!
    var invitedFriends = [Bool]()
    let locationManager = CLLocationManager()
    var typePickerData = [String]()
    var yelpSearchOption = "Food"
        
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var detailsTextField: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    private func initializeInvitedFriends() -> [Bool] {
        let checked = [Bool](count: listOfAllFriends().count, repeatedValue: false)
        return checked
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        invitedFriends = initializeInvitedFriends()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        friendsTableView.allowsMultipleSelection = true
        

        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        
        typePickerData = yelpSearchOptions()
        typePicker.selectRow(3, inComponent: 0, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAllFriends().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        let friend_username = listOfAllFriends()[indexPath.row].username
        
        if invitedFriends[indexPath.row] == false {
            cell.accessoryType = .None
        }
        else if invitedFriends[indexPath.row] == true {
            cell.accessoryType = .Checkmark
        }

        cell.textLabel?.text = friend_username
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            if cell.accessoryType == .Checkmark
            {
                cell.accessoryType = .None
                invitedFriends[indexPath.row] = false
            }
            else
            {
                cell.accessoryType = .Checkmark
                invitedFriends[indexPath.row] = true
            }
        }
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
    
    @IBAction func createEvent(sender: AnyObject) -> Void {
        let event_url = "https://halfway-db.herokuapp.com/v1/users/" + String(loggedInUser.id) + "/events"
        let realm = try! Realm()
        try! realm.write {
            self.logged_in_user().latitude = self.locationManager.location!.coordinate.latitude
        }
        
        try! realm.write {
            self.logged_in_user().longitude = self.locationManager.location!.coordinate.longitude
        }
        updateUserLocation()
        let parameters = [
            "event": [
                "date": datePicker.date,
                "description": detailsTextField.text!,
                "search_param": self.yelpSearchOption,
            ],
            
            "users": invitedFriendsIDs(),
        ]
        let alert = UIAlertView()
        if parameters["users"]?.length == 0 {
            alert.title = "Please Invite At Least One Friend"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        SVProgressHUD.show()
        let headers = ["Authorization": logged_in_user().access_token]
        request(.POST, event_url, parameters: parameters as? [String : AnyObject], headers: headers).validate().responseJSON { response in
            let json = response.result.value
            var event_details = json as! Dictionary<String, AnyObject>
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            event_details["date"] = dateFormatter.dateFromString(String(stringInterpolationSegment: event_details["date"]))
            event_details["details"] = event_details["description"]
            let created_event = Event(value: event_details)
            try! realm.write {
                self.logged_in_user().events.append(created_event)
            }
            SVProgressHUD.dismiss()
        }
    }
    
    func updateUserLocation() {
        let update_user_url = "https://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user().id)
        let parameters = [
            "user": [
                "latitude": logged_in_user().latitude,
                "longitude": logged_in_user().longitude
            ]
        ]
        request(.PATCH, update_user_url, parameters: parameters)
    }
    
    @IBAction func logOut(sender: AnyObject) -> Void {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    private func logged_in_user() -> User {
        let realm = try! Realm()
        return realm.objects(User).first!
    }
    
    private func invitedFriendsIDs() -> [Int] {
        var idList = [Int](count: invitedFriends.count, repeatedValue: 0)
        for invitedFriendsIndex in 0...(invitedFriends.count - 1) {
            if invitedFriends[invitedFriendsIndex] {
                idList[invitedFriendsIndex] = listOfAllFriends()[invitedFriendsIndex].id
            }
        }
        return idList
    }
    
    private func yelpSearchOptions() -> [String] {
        return [
            "Bar",
            "Boba",
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
    
    private func listOfAllFriends() -> List<User> {
        return logged_in_user().friends
    }
}
