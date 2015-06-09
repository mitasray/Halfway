//
//  Yelp.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/8/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

public class Yelp {
    
    var location: CLLocation
    var yelpAddressString = "search?find_desc=Restaurants&find_loc="
    
    public init(location: CLLocation) {
        self.location = location
    }
    
    public func getNearestLandmarks() -> String {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = (placemarks[0] as! CLPlacemark).addressDictionary
                var addressString: String = (pm["Street"] as! String) + "%2C" + (pm["City"] as! String) + "%2C" + (pm["State"] as! String)
    
                // The following code is largely based on https://www.yelp.com/developers/documentation/v2/iphone
                addressString = addressString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
                self.yelpAddressString += addressString + "&ns=1"
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
        return yelpAddressString
    }
}