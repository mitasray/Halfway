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


public class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let brain = HalfwayBrain()
    var currLocation : CLLocation! = nil
    var client = YelpClient()
    
    
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    
    
    @IBAction func donePressed(sender: AnyObject) {
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var targetLocation = CLLocation(latitude: geocode.getLatitude(), longitude: geocode.getLongitude())
        brain.setTargetLocation(targetLocation)
        var halfwayLocation = brain.calculateHalfwayLocation()
        client.setSearchLocation(halfwayLocation)
        var jsonResults = JSON(client.getJSON())
        
        println(jsonResults["businesses"])
        println(jsonResults["businesses"][0]["name"])
        
        var yelpResultLatitude = jsonResults["businesses"][0]["location"]["coordinate"]["latitude"].double
        var yelpResultLongitude = jsonResults["businesses"][0]["location"]["coordinate"]["longitude"].double
        if (yelpResultLongitude != nil) {
            var yelpLocation = CLLocation(latitude: yelpResultLatitude!, longitude: yelpResultLongitude!)
            map(yelpLocation, friendLocation: targetLocation, view: currentMapView)
        }
    }

    /**
     * Empty IBAction for when the outside view is tapped. Removes the keyboard from the display.
     */
    @IBAction func viewTapped(sender: AnyObject) {
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
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
        annotate(location, view: currentMapView, title: "Current Location")
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        view.setRegion(coordinateRegion, animated: true)
    }
    
    private func map(midLocation: CLLocation, friendLocation: CLLocation, view: MKMapView) {
        annotate(midLocation, view: currentMapView, title: String(stringInterpolationSegment: midLocation.coordinate.longitude))
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

