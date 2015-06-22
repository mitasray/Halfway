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
        var HTML = HTMLGetter(url: fullAddress)
        var HTMLString = HTML.getHTML()
        
        // String split method from: http://stackoverflow.com/questions/25678373/swift-split-a-string-into-an-array
        var latArr = HTMLString.componentsSeparatedByString("Latitude")
        var longArr = HTMLString.componentsSeparatedByString("Longitude")
        var latitude = numFinder(latArr[1] as! String)
        var longitude = numFinder(longArr[1] as! String)
        var coordinates = [Double]()
        coordinates.append(latitude)
        coordinates.append(longitude)
        return coordinates
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
        var urlAddress = address + " " + city + " " + state
        var myURLString = "http://geocoder.us/demo.cgi?address=" + urlAddress
        return myURLString
    }
}
