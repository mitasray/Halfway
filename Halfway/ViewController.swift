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
    
    @IBAction func findHalfway(sender: AnyObject) -> Void {
        // Checks to make sure that none of the text fields are empty.
        if (address.text == "" || city.text == "" || state.text == "") {
            return
        }
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var targetLocation = CLLocation(latitude: geocode.getLatitude(), longitude: geocode.getLongitude())
        if (brain.setTargetLocation(targetLocation)) {
            var halfwayLocation = brain.calculateHalfwayLocation()
            removeHalfwayAnnotation()
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
                    var resultLocation = String(stringInterpolationSegment: self.yelpJSON["businesses"][0]["name"])
                    var resultAddress = String(stringInterpolationSegment: self.yelpJSON["businesses"][0]["location"]["display_address"][0])
                    self.displayYelpResults(resultLocation, address: resultAddress)
                    self.map(yelpLocation, friendLocation: targetLocation, view: self.currentMapView, resultTitle: resultLocation, mapCords: self.brain.getMapCoordinates(yelpLocation))
                },
                failure: {(error:NSError!) -> Void in
                    println(error.localizedDescription)
                }
            )
            address.text = ""
            city.text = ""
            state.text = ""
        }
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
    
    private func map(midLocation: CLLocation, friendLocation: CLLocation, view: MKMapView, resultTitle: String, mapCords: [Double]) {
        // annotateMap(midLocation, view: currentMapView, title: String(stringInterpolationSegment: midLocation.coordinate.longitude))
        annotateMap(midLocation, view: currentMapView, title: resultTitle)
        annotateMap(friendLocation, view: currentMapView, title: "Friend's Location")
        let distance : Double = midLocation.distanceFromLocation(friendLocation)
        // let coordinateRegion = MKCoordinateRegionMakeWithDistance(midLocation.coordinate, (distance * 2) + 10, (distance * 2) + 10)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocation(latitude: mapCords[0], longitude: mapCords[1]).coordinate, mapCords[2] * 1.2, mapCords[3] * 1.2)
        view.setRegion(coordinateRegion, animated: true)
        
        // Automatically showing the "Halfway" annotation:
        // http://stackoverflow.com/questions/28198053/show-annotation-title-automatically
        var halfwayAnnotation : MKAnnotation = view.annotations[0] as! MKAnnotation
        
        // Finding the halfway annotation.
        for annObject in view.annotations {
            var annotation = annObject as! MKAnnotation
            if (annotation.title == resultTitle) {
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
    /**
     * Remove the halfway annotation. Used whenever a new address is entered.
     * http://stackoverflow.com/questions/10865088/how-do-i-remove-all-annotations-from-mkmapview-except-the-user-location-annotati
     */
    private func removeHalfwayAnnotation() -> Void {
        var halfwayAnnotation: MKAnnotation!
        let annotationsToRemove = currentMapView.annotations.filter {
            $0.title != "Current Location" && $0.title != "Friend's Location"
        }
        currentMapView.removeAnnotations(annotationsToRemove)
    }
}

