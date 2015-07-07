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
        var coordinates: [Double] = findLatLong(fullAddress())
        return coordinates[0]
    }
    
    public func getLongitude() -> Double {
        var coordinates: [Double] = findLatLong(fullAddress())
        return coordinates[1]
    }
    
    /**
     * Finding the latitude and longitude coordinates from a given address.
     * HTML source code obtained form getHTML(). This HTML code is then parsed for the correct latitude and longitude coordinates.
     * String split method from: http://stackoverflow.com/questions/25678373/swift-split-a-string-into-an-array
     */
    private func findLatLong(fullAddress : String) -> [Double] {
        var HTML = HTMLGetter(url: fullAddress)
        var HTMLString = HTML.getHTML()
        
        // The following line is for the case where the location is not found, since there can never be lat or long > 90. We will further handle this in other methods.
        if HTMLString.componentsSeparatedByString("\"lat\" : ").count == 1 {
            return [100, 100]
        }
        
        var latStr: String = HTMLString.componentsSeparatedByString("\"lat\" : ")[1].componentsSeparatedByString(",")[0] as! String
        var longStr: String = HTMLString.componentsSeparatedByString("\"lng\" : ")[1].componentsSeparatedByString("}")[0] as! String
        var latitude: Double = (latStr as NSString).doubleValue
        var longitude: Double = (longStr as NSString).doubleValue
        var coordinates: [Double] = [Double]()
        coordinates.append(latitude)
        coordinates.append(longitude)
        return coordinates
    }
    
    private func fullAddress() -> String {
        var urlAddress: String = address + " " + city + " " + state
        var myURLString: String = "https://maps.googleapis.com/maps/api/geocode/json?address=" + urlAddress
        return myURLString
    }
}