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

public class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let brain = HalfwayBrain()
    
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    
    /**
     * IBAction for when the done button is pressed. Creates the full address and calls findLatLong() to find the latitude and longitude coordinates of this full address.
     */
    @IBAction func donePressed(sender: AnyObject) {
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var targetLocation = CLLocation(latitude: geocode.getLatitude(), longitude: geocode.getLongitude())
        brain.setTargetLocation(targetLocation)
        var halfwayLocation = brain.calculateHalfwayLocation()
        map(halfwayLocation, view: currentMapView)
        annotate(halfwayLocation, view: currentMapView)
    }
    
    @IBAction func yelpPressed(sender: AnyObject) {
        // Parts of the following code are largely based on http://stackoverflow.com/questions/27495328/reverse-geocode-location-in-swift
        CLGeocoder().reverseGeocodeLocation(brain.calculateHalfwayLocation(), completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = (placemarks[0] as! CLPlacemark).addressDictionary
                var addressString: String = (pm["Street"] as! String) + "%2C" + (pm["City"] as! String) + "%2C" + (pm["State"] as! String)
                
                // The following code is largely based on https://www.yelp.com/developers/documentation/v2/iphone
                var yelpString = "search?find_desc=Restaurants&find_loc="
                addressString = addressString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
                yelpString += addressString + "&ns=1"
                if (self.isYelpInstalled()) {
                    // Call into the Yelp app
                    UIApplication.sharedApplication().openURL(NSURL(string: "yelp4:///" + yelpString)!);
                } else {
                    // Use the Yelp touch site
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://yelp.com/" + yelpString)!);
                }
                
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
    }

    /**
     * Empty IBAction for when the outside view is tapped. Removes the keyboard from the display.
     */
    @IBAction func viewTapped(sender: AnyObject) {
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up MapKit to track current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.currentMapView?.showsUserLocation = true
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        brain.setCurrentLocation(locations.last as! CLLocation)
        map(brain.getCurrentLocation(), view: currentMapView)
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
    
    private func isYelpInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "yelp4:")!);
    }
}

