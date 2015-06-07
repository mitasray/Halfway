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
// Map Tutorial: http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var targetLocation = CLLocation(latitude: 0, longitude: 0)
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    @IBOutlet weak var currentLatitude: UILabel!
    @IBOutlet weak var currentLongitude: UILabel!
    @IBOutlet weak var halfwayLatitude: UILabel!
    @IBOutlet weak var halfwayLongitude: UILabel!
    
    /**
     * IBAction for when the done button is pressed. Creates the full address and calls findLatLong() to find the latitude and longitude coordinates of this full address.
     */
    @IBAction func donePressed(sender: AnyObject) {
        var geocode = Geocoder(address: address.text, city: city.text, state: state.text)
        var currLatitude = geocode.getLatitude()
        var currLongitude = geocode.getLongitude()
        targetLocation = CLLocation(latitude: currLatitude, longitude: currLongitude)
        
        var halfwayLocation = halfway(targetLocation, location2: currentLocation)
        halfwayLatitude.text = String(stringInterpolationSegment: halfwayLocation.coordinate.latitude)
        halfwayLongitude.text = String(stringInterpolationSegment: halfwayLocation.coordinate.longitude)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView?.showsUserLocation = true
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
        
        currentLatitude.text = String(format: "%.4f", currLatitude)
        currentLongitude.text = String(format: "%.4f", currLongitude)
        
        var location = CLLocation(latitude: currLatitude, longitude: currLongitude)
        centerMapOnLocation(location)
    }

    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

