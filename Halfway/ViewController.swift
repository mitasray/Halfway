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

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var targetLocation = CLLocation(latitude: 0, longitude: 0)
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    var halfwayLocation = CLLocation(latitude: 0, longitude: 0)
    
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
        halfwayLocation = halfway(targetLocation, location2: currentLocation)
        map(halfwayLocation, view: halfwayMapView)
        annotate(halfwayLocation, view: halfwayMapView)
    }

    /**
     * Empty IBAction for when the outside view is tapped. Removes the keyboard from the display.
     */
    @IBAction func viewTapped(sender: AnyObject) {
    }
    
    /**
     * https://www.yelp.com/developers/documentation/v2/iphone
     * IBAction for when yelp button is pressed. Redirects the user into the Yelp app or the yelp mobile website depending on whether the Yelp app downloaded on their device.
     */
    @IBAction func yelpPressed(sender: AnyObject) {
        var yelp = Yelp(location: halfwayLocation)
        var yelpAddressString = yelp.getNearestLandmarks()
        var yelpNSURL = "http://yelp.com/"
        if(isYelpInstalled()) {
            var yelpNSURL = "yelp4:///"
        }
        UIApplication.sharedApplication().openURL(NSURL(string: yelpNSURL + yelpAddressString)!);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up MapKit to track current location
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
        self.currentLocation = locations.last as! CLLocation
        map(currentLocation, view: currentMapView)
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
    
    private func halfway(location1: CLLocation, location2: CLLocation) -> CLLocation {
        var lat = (location1.coordinate.latitude + location2.coordinate.latitude) / 2
        var long = (location1.coordinate.longitude + location2.coordinate.longitude) / 2
        return CLLocation(latitude: lat, longitude: long)
    }
    
    private func isYelpInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "yelp4:")!);
    }
}

