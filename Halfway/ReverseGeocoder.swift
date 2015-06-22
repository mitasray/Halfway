//
//  ReverseGeocoder.swift
//  Halfway
//
//  Created by Mitas Ray on 6/22/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import CoreLocation

public class ReverseGeocoder {
    public var loc: CLLocation
    
    public init(loc: CLLocation) {
        self.loc = loc
    }
    
    public func getAddressString() -> String {
        var addressString: String = ""
        
        // Parts of the following code are largely based on http://stackoverflow.com/questions/27495328/reverse-geocode-location-in-swift
        CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = (placemarks[0] as! CLPlacemark).addressDictionary
                addressString = (pm["Street"] as! String) + "%2C" + (pm["City"] as! String) + "%2C" + (pm["State"] as! String)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
        return addressString
    }
}
