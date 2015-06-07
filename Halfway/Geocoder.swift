//
//  Geocoder.swift
//  Halfway
//
//  Created by Kevin Arifin on 6/7/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation

public class Geocoder {
    
    var address: String
    var city: String
    var state: String
    
    public init(address: String, city: String, state: String) {
        self.address = address
        self.city = city
        self.state = state
    }
    
    public func getLatitude() -> Double {
        var coordinates = findLatLong(fullAddress())
        return coordinates[0]
    }
    
    public func getLongitude() -> Double {
        var coordinates = findLatLong(fullAddress())
        return coordinates[1]
    }
    
    /**
    * Finding the latitude and longitude coordinates from a given address.
    * HTML source code obtained form getHTML(). This HTML code is then parsed for the correct latitude and longitude coordinates.
    */
    private func findLatLong(fullAddress : String) -> [Double] {
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
    * http://stackoverflow.com/questions/26134884/how-to-get-html-source-from-url-with-swift
    * Returns the HTML source code of the geocoder.us webpage with the proper address.
    */
    private func getHTML(fullAddress : String) -> NSString {
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
    * Helper method for findLatLong().
    * Removes the </h3></td>\n    <td> HTML code and the excess end HTML code from the latitude and longitude coordinates to only extract the numbers.
    */
    private func numFinder(coord : String) -> Double {
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
    
    private func fullAddress() -> String {
        return address + " " + city + " " + state
    }
}
