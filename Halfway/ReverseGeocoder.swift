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
    
    /**
     * http://stackoverflow.com/questions/27495328/reverse-geocode-location-in-swift
     * https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/#//apple_ref/c/tdef/NSSearchPathDirectory
     * Actual filepath: /Users/Mitas/Xcode Projects/Halfway/Halfway/address.txt
     */
    public func getAddressString() -> Void {
        CLGeocoder().reverseGeocodeLocation(self.loc, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
            }
            if placemarks.count > 0 {
                let pm = (placemarks[0] as! CLPlacemark).addressDictionary
                var addressString = (pm["Street"] as! String) + "%2C" + (pm["City"] as! String) + "%2C" + (pm["State"] as! String)
                // let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.UserDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as! [String]
                // let filename: String = "Mitas/Xcode Projects/Halfway/Halfway/address.txt"
                // let path = dirs[0].stringByAppendingPathComponent(filename)
                // let pathR = "~/Xcode Projects/Halfway/Halfway/address.txt"
                let path = "/Users/Mitas/Xcode Projects/Halfway/Halfway/address.txt"
                addressString.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    /**
     * http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
     * Method is written here as a reference.
     */
    public func write(string: String) {
        let path = "/Users/Mitas/Xcode Projects/Halfway/Halfway/address.txt"
        string.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    /**
     * http://stackoverflow.com/questions/24097826/read-and-write-data-from-text-file
     */
    public func read() -> String {
        let dirs : [String] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.UserDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as! [String]
        let filename: String = "Mitas/Xcode Projects/Halfway/Halfway/address.txt"
        let path = dirs[0].stringByAppendingPathComponent(filename)
        return String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)!
    }
}
