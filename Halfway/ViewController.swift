//
//  ViewController.swift
//  Halfway
//
//  Created by Mitas Ray on 6/3/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SwiftyJSON
import Alamofire



public class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var currLocation : CLLocation! = nil
    var yelpClient = YelpClient.sharedInstance
    let brain = HalfwayBrain()
    var yelpJSON = JSON([])
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    @IBOutlet weak var yelpLocationResult: UILabel!
    @IBOutlet weak var yelpAddressResult: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    
    
    @IBAction func logOut(sender: AnyObject) {
        self.defaults.removeObjectForKey("username")
        
        resetFields()
        
        var loginController: LoginController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginController
        
        self.navigationController?.pushViewController(loginController, animated: true)
    }
    
    @IBAction func findHalfway(sender: AnyObject) {
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var targetLocation = CLLocation(latitude: geocode.getLatitude(), longitude: geocode.getLongitude())
        brain.setTargetLocation(targetLocation)
        var halfwayLocation = brain.calculateHalfwayLocation()
        
        yelpClient.setSearchLocation(halfwayLocation)
        yelpClient.client.get(
            yelpClient.yelpApiUrl,
            parameters: yelpClient.params,
            success: { (data, response) -> Void in
                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                self.yelpJSON = JSON(json)
                var yelpResultLatitude = self.yelpJSON["businesses"][0]["location"]["coordinate"]["latitude"].double
                var yelpResultLongitude = self.yelpJSON["businesses"][0]["location"]["coordinate"]["longitude"].double
                
                var yelpLocation = CLLocation(latitude: yelpResultLatitude!, longitude: yelpResultLongitude!)
                self.map(yelpLocation, friendLocation: targetLocation, view: self.currentMapView)
                var resultLocation = String(stringInterpolationSegment: self.yelpJSON["businesses"][0]["name"])
                
                var resultAddress = String(stringInterpolationSegment: self.yelpJSON["businesses"][0]["location"]["display_address"][0])
                self.displayYelpResults(resultLocation, address: resultAddress)
            },
            failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
            }
        )
    }
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    public override func viewDidAppear(animated: Bool) {        
        var loginController: LoginController = self.storyboard?.instantiateViewControllerWithIdentifier("Login") as! LoginController
        
        if !loggedIn() {
            self.navigationController?.pushViewController(loginController, animated: true)
        } else {
            currentUserLabel.text = "You are logged in as " + currentUser()
        }
    }
    
    private func loggedIn() -> Bool {
        if let name = defaults.stringForKey("username") {
            return true
        } else {
            return false
        }
    }
    
    private func currentUser() -> String {
        return self.defaults.stringForKey("username")!
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (currLocation == nil) {
            currLocation = locations.last as! CLLocation
        }
        self.locationManager.stopUpdatingLocation()
        
        brain.setCurrentLocation(locations.last as! CLLocation)
        map(brain.getCurrentLocation(), view: currentMapView)
    }


    private func map(location: CLLocation, view: MKMapView) {
        annotateMap(location, view: currentMapView, title: "Current Location")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        view.setRegion(coordinateRegion, animated: true)
    }
    
    private func map(midLocation: CLLocation, friendLocation: CLLocation, view: MKMapView) {
        annotateMap(midLocation, view: currentMapView, title: "Meeting Point")
        annotateMap(friendLocation, view: currentMapView, title: "Friend's Location")
        let distance : Double = midLocation.distanceFromLocation(friendLocation)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(midLocation.coordinate, (distance * 2) + 10, (distance * 2) + 10)
        view.setRegion(coordinateRegion, animated: true)
        
        // Automatically showing the "Halfway" annotation:
        // http://stackoverflow.com/questions/28198053/show-annotation-title-automatically
        var halfwayAnnotation : MKAnnotation = view.annotations[0] as! MKAnnotation
        
        // Finding the halfway annotation.
        for annObject in view.annotations {
            var annotation = annObject as! MKAnnotation
            if (annotation.title == "Halfway") {
                halfwayAnnotation = annotation
            }
        }
        view.selectAnnotation(halfwayAnnotation, animated: true)
    }
    
    /* Removes the keyboard from the display. */
    @IBAction func viewTapped(sender: AnyObject) {
    }
    
    private func annotateMap(location: CLLocation, view: MKMapView, title: String) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        view.addAnnotation(annotation)
    }

    private func displayYelpResults(location: String, address: String) {
        yelpLocationResult.text = location
        yelpAddressResult.text = address
    }
    
    private func resetFields() {
        map(brain.getCurrentLocation(), view: currentMapView)
        address.text = ""
        city.text = ""
        state.text = ""
        yelpLocationResult.text = ""
        yelpAddressResult.text = ""
    }
}

