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
    
    var currLocation : CLLocation! = nil
    
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var resultAddress: UILabel!
    @IBOutlet weak var resultCSZ: UILabel!
    @IBOutlet weak var resultStar: UILabel!
    @IBOutlet weak var resultReviews: UILabel!
    @IBOutlet weak var resultType: UILabel!
    @IBOutlet weak var resultPrice: UILabel!
    @IBOutlet weak var resultPhone: UILabel!
    
    var doneAlreadyPressed: Bool = false
    var randomSearchID: Int = -1
    var results: [Result] = []
    /**
     * IBAction for when the done button is pressed. Creates the full address and calls findLatLong() to find the latitude and longitude coordinates of this full address.
     */
    @IBAction func donePressed(sender: AnyObject) {
        if (!doneAlreadyPressed) {
            doneAlreadyPressed = true
            var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
            var targetLocation = CLLocation(latitude: geocode.getLatitude(), longitude: geocode.getLongitude())
            brain.setTargetLocation(targetLocation)
            var halfwayLocation = brain.calculateHalfwayLocation()
            map(halfwayLocation, friendLocation: targetLocation, view: currentMapView)
            let yelpHTML = YelpHTML(halfwayLocation: halfwayLocation)
            results = yelpHTML.getResults()
        }
        randomSearchID = pickRandom(results.count, not: randomSearchID)
        showResult(results[randomSearchID]);
    }
    
    /**
     * Returns a random number from 0 to size - 1 that does not equal the variable not.
     */
    public func pickRandom(size: Int, not: Int) -> Int {
        if (size <= 1) {
            return 0
        }
        var returnVar: Int = not
        while (returnVar == not) {
            returnVar = Int(arc4random_uniform(UInt32(size)))
        }
        return returnVar
    }
    
    /**
     * Configures all the labels to display the information corresponding to the input search result.
     */
    public func showResult(result: Result) {
        resultName.text = result.name
        resultAddress.text = result.address
        resultCSZ.text = result.cityStateZip
        resultStar.text = result.star
        resultReviews.text = result.reviews
        resultType.text = result.type
        resultPrice.text = result.price
        resultPhone.text = result.phone
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

