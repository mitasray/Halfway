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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    @IBOutlet weak var currentLatitude: UILabel!
    @IBOutlet weak var currentLongitude: UILabel!
    @IBOutlet weak var halfwayLatitude: UILabel!
    @IBOutlet weak var halfwayLongitude: UILabel!
    
    var targetLocation: Location = Location(latitude: 0, longitude: 0)
    var currentLocation: Location = Location(latitude: 0, longitude: 0)
    
    /**
     * IBAction for when the done button is pressed. Creates the full address and calls findLatLong() to find the latitude and longitude coordinates of this full address.
     */
    @IBAction func donePressed(sender: AnyObject) {
        var target = findLatLong(fullAddress())
        targetLocation.setLatitude(target[0])
        targetLocation.setLongitude(target[1])
        halfwayLatitude.text = String(stringInterpolationSegment: currentLocation.halfway(targetLocation).latitude())
        halfwayLongitude.text = String(stringInterpolationSegment: currentLocation.halfway(targetLocation).longitude())
    }
    
    /**
     * http://stackoverflow.com/questions/26134884/how-to-get-html-source-from-url-with-swift
     * Returns the HTML source code of the geocoder.us webpage with the proper address.
     */
    func getHTML(fullAddress : String) -> NSString {
        var urlAddress = fullAddress.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let myURLString = "http://geocoder.us/demo.cgi?address=" + urlAddress
        
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                println("Error : \(error)")
            } else {
                // println("HTML : \(myHTMLString)")
                return myHTMLString!
            }
        } else {
            println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
        return NSString(string: "") // Empty NSString is returned if HTML is not a valid URL
    }
    
    /**
     * Finding the latitude and longitude coordinates from a given address.
     * HTML source code obtained form getHTML(). This HTML code is then parsed for the correct latitude and longitude coordinates.
     */
    func findLatLong(fullAddress : String) -> [Double] {
        var HTMLString = String(getHTML(fullAddress))
        
        // String split method from: http://stackoverflow.com/questions/25678373/swift-split-a-string-into-an-array
        var latArr = HTMLString.componentsSeparatedByString("Latitude")
        var longArr = HTMLString.componentsSeparatedByString("Longitude")
        var latitude = numFinder(latArr[1])
        var longitude = numFinder(longArr[1])
        var coordinates = [Double]()
        coordinates.append(latitude)
        coordinates.append(longitude)
        return coordinates
    }
    
    /**
     * Helper method for findLatLong(). 
     * Removes the </h3></td>\n    <td> HTML code and the excess end HTML code from the latitude and longitude coordinates to only extract the numbers.
     */
    func numFinder(coord : String) -> Double {
        var finalCoord = coord.substringFromIndex(advance(coord.startIndex, 19))
        var posOfSpace = posOfChar(coord, char: " ");
        finalCoord = finalCoord.substringToIndex(advance(coord.startIndex, posOfSpace))
        var finalCoordDouble : Double = (finalCoord as NSString).doubleValue // String to Double
        return finalCoordDouble
    }
    
    /**
     * Solution #3 from: http://stackoverflow.com/questions/24029163/finding-index-of-character-in-swift-string
     * Helper method for numFinder().
     * Returns the position of a character in a string, where the character and string are parameters. If character not found, returns -1.
     */
    func posOfChar(string : String, char : Character) -> Int {
        if let index = find(string, char) {
            let pos = distance(string.startIndex, index)
            return pos
        } else {
            return -1
        }
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var currentLocation: AnyObject = locations[locations.count - 1]
        
        var currentCoordinates = currentLocation.coordinate
        var currLatitude = currentCoordinates.latitude
        var currLongitude = currentCoordinates.longitude
        
        currentLatitude.text = String(format: "%.4f", currLatitude)
        currentLongitude.text = String(format: "%.4f", currLongitude)
        
        self.currentLocation.setLatitude(currLatitude)
        self.currentLocation.setLongitude(currLongitude)
    }
    
    private func fullAddress() -> String {
        return address.text + " " + city.text + " " + state.text
    }
}

