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

public class EventController: UIViewController, FriendsControllerDelegate, YelpSearchOptionsDelegate, CLLocationManagerDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    let brain = HalfwayBrain()
    let yelpClient = YelpClient.sharedInstance
    
    var yelpJSON = JSON([])
    
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var yelpLocationNameLabel: UILabel!
    @IBOutlet weak var yelpResultAddressButton: UIButton!
    @IBOutlet weak var yelpSearchOption: UIButton!
    @IBOutlet weak var createEventButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public func createEventWithFriend(friend: User) {
        friendLabel.text =  friend.username
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
        if !addressIsInputted() {
            return
        }
        
        var fullAddress = composeFullAddress()
        var geocoder = CLGeocoder()

        geocoder.geocodeAddressString(
            fullAddress,
            completionHandler: {(placemarks:[AnyObject]!, error: NSError!) -> Void in
                if let placemark = placemarks?[0] as? CLPlacemark {
                    if self.brain.setTargetLocation(placemark.location) {
                        var halfwayLocation: CLLocation = self.brain.calculateHalfwayLocation()
                        self.yelpClient.setSearchLocation(halfwayLocation)
                        self.yelpClient.client.get(
                            self.yelpClient.yelpApiUrl,
                            parameters: self.yelpClient.params,
                            success: { (data, response) -> Void in
                                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                                self.yelpJSON = JSON(json)
                                var yelpResult = self.yelpJSON["businesses"][0]
                                var yelpResultLatitude: Double = yelpResult["location"]["coordinate"]["latitude"].double!
                                var yelpResultLongitude: Double = yelpResult["location"]["coordinate"]["longitude"].double!
                                var yelpLocation: CLLocation = CLLocation(latitude: yelpResultLatitude, longitude: yelpResultLongitude)
                                var resultLocation: String = String(stringInterpolationSegment: yelpResult["name"])
                                var resultAddress: String = String(stringInterpolationSegment: yelpResult["location"]["display_address"][0])
                                self.displayYelpResults(resultLocation, address: resultAddress)
                            },
                            failure: {(error:NSError!) -> Void in
                                println(error.localizedDescription)
                            }
                        )
                        self.addressField.text = ""
                        self.cityField.text = ""
                        self.stateField.text = ""
                }
            }
        })
    }
    
    @IBAction func logOut(sender: AnyObject) -> Void {
        for key in defaults.dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
        resetFields()
    }
    
    @IBAction func removeKeyboardFromScreen(sender: AnyObject) -> Void {
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) -> Void {
        brain.setCurrentLocation(locations.last as! CLLocation)
    }
    
    private func composeFullAddress() -> String {
        return addressField.text + ", " + cityField.text + ", " + stateField.text
    }
    
    private func addressIsInputted() -> Bool {
        return addressField.text != "" || cityField.text == "" || stateField.text == ""
    }
    
    private func resetFields() -> Void {
        addressField.text = ""
        cityField.text = ""
        stateField.text = ""
        yelpLocationNameLabel.text = ""
        yelpResultAddressButton.setTitle("", forState: UIControlState())
    }
    
    private func currentUser() -> String {
        return self.defaults.stringForKey("username")!
    }
    
    private func displayYelpResults(location: String, address: String) {
        yelpLocationNameLabel.text = location
        yelpResultAddressButton.setTitle(address, forState: UIControlState())
    }
}
