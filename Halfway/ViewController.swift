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

public class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let locationManager = CLLocationManager()
    var currLocation: CLLocation! = nil
    var yelpClient: YelpClient = YelpClient.sharedInstance
    let brain: HalfwayBrain = HalfwayBrain()
    var yelpJSON: JSON = JSON([])
    let defaults = NSUserDefaults.standardUserDefaults()
    var type: String = "food"
    
    @IBAction func search(sender: AnyObject) {
        var searchController: SearchController = self.storyboard?.instantiateViewControllerWithIdentifier("Search") as! SearchController
        self.navigationController?.pushViewController(searchController, animated: true)
    }
    
    @IBAction func friends(sender: AnyObject) {
        var friendsController: FriendsController = self.storyboard?.instantiateViewControllerWithIdentifier("Friends") as! FriendsController
        self.navigationController?.pushViewController(friendsController, animated: true)
    }
    
    @IBOutlet weak var searchOption: UIButton!
    
    @IBAction func yelpSearchOptions(sender: AnyObject) {
        // All the work is done in the prepareForSegue(...) method
    }
    
    public func buttonDelegateMethodWithString(string: String) {
        type = string
        searchOption.setTitle(string + " >", forState: UIControlState.Normal)
    }
    
    /**
     * http://makeapppie.com/2014/07/01/swift-swift-using-segues-and-delegates-in-navigation-controllers-part-1-the-template/
     */

    
    @IBOutlet weak var currentMapView: MKMapView!
    @IBOutlet var address: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet weak var yelpLocationResult: UILabel!
    @IBOutlet weak var currentUserLabel: UILabel!
    @IBOutlet weak var yelpAddress: UIButton!
    
    @IBAction func logOut(sender: AnyObject) -> Void {
        for key in defaults.dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
        resetFields()
    }
    
    /**
     * Using CLGeocoder: http://stackoverflow.com/questions/24706885/how-can-i-plot-addresses-in-swift-converting-address-to-longitude-and-latitude
     */
    @IBAction func findHalfway(sender: AnyObject) -> Void {
        // Checks to make sure that none of the text fields are empty.
        if address.text == "" || city.text == "" || state.text == "" {
            return
        }
        
        var fullAddress: String = address.text + ", " + city.text + ", " + state.text
        var geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(fullAddress, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            if let placemark = placemarks?[0] as? CLPlacemark {
                if self.brain.setTargetLocation(placemark.location) {
                    var halfwayLocation: CLLocation = self.brain.calculateHalfwayLocation()
                    self.removeHalfwayAnnotation()
                    self.yelpClient.setSearchLocation(halfwayLocation, type: self.type)
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
                            self.map(yelpLocation, friendLocation: placemark.location, view: self.currentMapView, resultTitle: resultLocation)
                        },
                        failure: {(error:NSError!) -> Void in
                            println(error.localizedDescription)
                        }
                    )
                    self.address.text = ""
                    self.city.text = ""
                    self.state.text = ""
                }
            }
        })
    }
    

    public override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.currentMapView.delegate = self
    }
    
    public override func viewDidAppear(animated: Bool) -> Void {
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
    
    public override func didReceiveMemoryWarning() -> Void {
        super.didReceiveMemoryWarning()
    }

    public func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) -> Void {
        if currLocation == nil {
            currLocation = locations.last as! CLLocation
        }
        self.locationManager.stopUpdatingLocation()
        
        brain.setCurrentLocation(locations.last as! CLLocation)
        map(brain.getCurrentLocation(), view: currentMapView)
    }


    private func map(location: CLLocation, view: MKMapView) -> Void {
        annotateMap(location, view: currentMapView, title: "Current Location")
        let coordinateRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 200, 200)
        view.setRegion(coordinateRegion, animated: true)
    }
    
    private func map(midLocation: CLLocation, friendLocation: CLLocation, view: MKMapView, resultTitle: String) -> Void {
        annotateMap(midLocation, view: currentMapView, title: resultTitle)
        annotateMap(friendLocation, view: currentMapView, title: "Friend's Location")
        let distance: Double = midLocation.distanceFromLocation(friendLocation)
        
        // Automatically showing the "Halfway" annotation:
        // http://stackoverflow.com/questions/28198053/show-annotation-title-automatically
        var halfwayAnnotation: MKAnnotation = view.annotations[0] as! MKAnnotation
        
        // Finding the halfway annotation.
        for annObject: AnyObject in view.annotations {
            var annotation = annObject as! MKAnnotation
            if annotation.title == resultTitle {
                halfwayAnnotation = annotation
                view.centerCoordinate = halfwayAnnotation.coordinate
            }
        }
        
        var maxDistance: Double = 0
        for annObject: AnyObject in view.annotations {
            var annotation = annObject as! MKAnnotation
            var distance: Double = CLLocation(latitude: halfwayAnnotation.coordinate.latitude, longitude: halfwayAnnotation.coordinate.longitude).distanceFromLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
            if distance > maxDistance {
                maxDistance = distance
            }
        }
        let coordinateRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(halfwayAnnotation.coordinate, maxDistance * 2, maxDistance * 2)
        view.setRegion(coordinateRegion, animated: true)
        view.selectAnnotation(halfwayAnnotation, animated: true)
    }
    
    /**
     * http://studyswift.blogspot.com/2014/10/viewforannotation-pincolor-change-pin.html
     */
    public func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        var myPin = mapView.dequeueReusableAnnotationViewWithIdentifier("MyIdentifier") as? MKPinAnnotationView
        if myPin != nil {
            return myPin
        }
        
        myPin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MyIdentifier")
        if annotation.title == "Friend's Location" || annotation.title == "Current Location" {
            myPin?.pinColor = .Red
        } else {
            myPin?.pinColor = .Green
        }
        myPin!.canShowCallout = true
        return myPin
    }

    /** Removes the keyboard from the display. */
    @IBAction func viewTapped(sender: AnyObject) -> Void {
    }
    
    private func annotateMap(location: CLLocation, view: MKMapView, title: String) -> Void {
        var annotation: MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = title
        view.addAnnotation(annotation)
    }

    private func displayYelpResults(location: String, address: String) {
        yelpLocationResult.text = location
        yelpAddress.setTitle(address, forState: UIControlState())
    }
    
    private func resetFields() -> Void {
        map(brain.getCurrentLocation(), view: currentMapView)
        address.text = ""
        city.text = ""
        state.text = ""
        yelpLocationResult.text = ""
        yelpAddress.setTitle("", forState: UIControlState())
    }
    
    @IBAction func appleMapAddress(sender: AnyObject) {
    }
    
    /**
     * Remove the halfway annotation. Used whenever a new address is entered.
     * http://stackoverflow.com/questions/10865088/how-do-i-remove-all-annotations-from-mkmapview-except-the-user-location-annotati
     */
    private func removeHalfwayAnnotation() -> Void {
        var halfwayAnnotation: MKAnnotation!
        let annotationsToRemove: [AnyObject] = currentMapView.annotations.filter {
            $0.title != "Current Location" && $0.title != "Friend's Location"
        }
        currentMapView.removeAnnotations(annotationsToRemove)
    }
}
