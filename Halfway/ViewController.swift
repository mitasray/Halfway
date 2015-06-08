//
//  ViewController.swift
//  Halfway
//
//  Created by Mitas Ray on 6/3/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
import CoreLocation
// Map Tutorial: http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var targetLocation = CLLocation(latitude: 0, longitude: 0)
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    
    // Global variables. Initializers.
    var midpointLat : Double = 0.0
    var midpointLong : Double = 0.0
    
    // IBOutlets.
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet weak var halfwayMapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    
    /**
     * IBAction for when the done button is pressed. Creates the full address and calls findLatLong() to find the latitude and longitude coordinates of this full address.
     */
    @IBAction func donePressed(sender: AnyObject) {
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var currLatitude = geocode.getLatitude()
        var currLongitude = geocode.getLongitude()
        targetLocation = CLLocation(latitude: currLatitude, longitude: currLongitude)
        
        var halfwayLocation = halfway(targetLocation, location2: currentLocation)
        
        midpointLat = halfwayLocation.coordinate.latitude
        midpointLong = halfwayLocation.coordinate.longitude
        
        map(halfwayLocation, view: halfwayMapView)
        annotate(halfwayLocation, view: halfwayMapView)
    }
    
    private func halfway(location1: CLLocation, location2: CLLocation) -> CLLocation {
        var lat = (location1.coordinate.latitude + location2.coordinate.latitude) / 2
        var long = (location1.coordinate.longitude + location2.coordinate.longitude) / 2
        return CLLocation(latitude: lat, longitude: long)
    }

    /**
     * Empty IBAction for when the outside view is tapped. Removes the keyboard from the display.
     */
    @IBAction func viewTapped(sender: AnyObject) {
        // Empty.
    }
    
    /**
     * https://www.yelp.com/developers/documentation/v2/iphone
     * IBAction for when yelp button is pressed. Redirects the user into the Yelp app or the yelp mobile website depending on whether the Yelp app downloaded on their device.
     */
    @IBAction func yelpPressed(sender: AnyObject) {
        doSomethingWithYelp(String(format: "%f", midpointLat), longitude: String(format: "%f", midpointLong))
    }
    
    /**
     * Checks to see whether the user has Yelp installed on their device.
     */
    func isYelpInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "yelp4:")!);
    }
    
    /**
     * Enters the location and runs the search.
     */
    func doSomethingWithYelp(latitude: String, longitude: String) {
        var yelpString = "search?category=restaurants&location="
        if (isYelpInstalled()) {
            // Call into the Yelp app
            UIApplication.sharedApplication().openURL(NSURL(string: "yelp4:///" + yelpString)!);
        } else {
            // Use the Yelp touch site
            UIApplication.sharedApplication().openURL(NSURL(string: "http://yelp.com/" + yelpString)!);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // The following lines are used for obtaining the current location and using MapKit with this location. Setup.
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.currentMapView?.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocation = locations.last as! CLLocation
        self.currentLocation = currentLocation
        var currentCoordinates = currentLocation.coordinate
        var currLatitude = currentCoordinates.latitude
        var currLongitude = currentCoordinates.longitude
        
        var location = CLLocation(latitude: currLatitude, longitude: currLongitude)
        map(location, view: currentMapView)
    }

    private func map(location: CLLocation, view: MKMapView) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        view.setRegion(coordinateRegion, animated: true)
    }
    
    private func annotate(location: CLLocation, view: MKMapView) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Halfway"
        view.addAnnotation(annotation)
    }
}

