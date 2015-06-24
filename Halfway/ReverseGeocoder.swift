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
     * http://maps.googleapis.com/maps/api/geocode/json?latlng=37.866579,-122.255807&sensor=true
     */
    public func getAddressString() -> String {
        var link: String = "http://maps.googleapis.com/maps/api/geocode/json?latlng="
        link += String(format:"%f", loc.coordinate.latitude) + "," + String(format:"%f", loc.coordinate.longitude)
        link += "&sensor=true"
        var linkHTML = HTMLGetter(url: link).getHTML()
        var fullAddress: String = linkHTML.componentsSeparatedByString("formatted_address\" : \"")[1].componentsSeparatedByString("\"")[0] as! String
        var addressArr = fullAddress.componentsSeparatedByString(",")
        var count = addressArr.count
        return addressArr[count - 4] + addressArr[count - 3] + addressArr[count - 2]
    }
}
