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
import OAuthSwift

public class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let brain = HalfwayBrain()
    
    var currLocation : CLLocation! = nil
    
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    
    var client = OAuthSwiftClient(consumerKey: "5j9mbUKOpxkAsugIAhI5vw", consumerSecret: "e2NKNi7NLjubnMPGrjXChqDX-5c", accessToken: "brQj6wDEEUY_D5cHskczigza3fHN50Jz", accessTokenSecret: "f4PL09-I04apg086jUoC5J6M4JA")
    
    /**
     * IBAction for when the done button is pressed. Creates the full address and calls findLatLong() to find the latitude and longitude coordinates of this full address.
     */

    @IBAction func action(sender: AnyObject) {
        let params: [String: String] = [
            "location": "San+Francisco",
            "term": "seafood"
        ]
        client.get(
            "https://api.yelp.com/v2/search",
            parameters: params,
            success: { (data, response) -> Void in
                let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
                println(json)
            },
            failure: {(error:NSError!) -> Void in
                println(error.localizedDescription)
            }
        )
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var targetLocation = CLLocation(latitude: geocode.getLatitude(), longitude: geocode.getLongitude())
        brain.setTargetLocation(targetLocation)
        var halfwayLocation = brain.calculateHalfwayLocation()
        map(halfwayLocation, friendLocation: targetLocation, view: currentMapView)
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
        
        // Sets up MapKit to track current location.
        // Used: http://stackoverflow.com/questions/28852683/dropping-pin-current-location-xcode6-swift
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // self.locationManager.stopUpdatingLocation()
        // The following line shows the blue point at the user's location.
        // self.currentMapView?.showsUserLocation = true
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (currLocation == nil) {
            currLocation = locations.last as! CLLocation
        }
        // The following line makes sure that we only get one location and do not have to keep updating the current location of the user.
        self.locationManager.stopUpdatingLocation()
        
        brain.setCurrentLocation(locations.last as! CLLocation)
        map(brain.getCurrentLocation(), view: currentMapView)
    }


    private func map(location: CLLocation, view: MKMapView) {
        annotate(location, view: currentMapView, title: "Current Location")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        view.setRegion(coordinateRegion, animated: true)
    }
    
    private func map(midLocation: CLLocation, friendLocation: CLLocation, view: MKMapView) {
        annotate(midLocation, view: currentMapView, title: "Halfway")
        annotate(friendLocation, view: currentMapView, title: "Friend's Location")
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

    private func annotate(location: CLLocation, view: MKMapView, title: String) {
        var annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        view.addAnnotation(annotation)
    }

    private func isYelpInstalled() -> Bool {
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "yelp4:")!);
    }
}

