//
//  YelpHTML.swift
//  Halfway
//
//  Created by Mitas Ray on 6/21/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import CoreLocation

public class YelpHTML {
    public var halfwayLocation: CLLocation
    
    public init(halfwayLocation: CLLocation) {
        self.halfwayLocation = halfwayLocation
    }
    
    public func getResults() -> [Result] {
        var results = [Result]()
        var addressString: String = ReverseGeocoder(loc: halfwayLocation).getAddressString()
        
        // The following code is largely based on https://www.yelp.com/developers/documentation/v2/iphone
        var yelpString = "search?find_desc=Restaurants&find_loc="
        addressString = addressString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        yelpString = "http://yelp.com/" + yelpString + addressString + "&ns=1"
        
        var HTML = HTMLGetter(url: yelpString)
        var HTMLString = HTML.getHTML();
        var arr = HTMLString.componentsSeparatedByString("<span class=\"indexed-biz-name\">")
        for index in 1 ... (arr.count - 1) {
            var arrIndex: String = arr[index] as! String
            var name: String = arrIndex.componentsSeparatedByString(">")[1].componentsSeparatedByString("<")[0]
            var starPreString = arrIndex.componentsSeparatedByString("title=\"")[1]
            var star: String = starPreString.substringWithRange(Range<String.Index>(start: advance(starPreString.startIndex, 0), end: advance(starPreString.startIndex, 3)))
            var reviews: String = arrIndex.componentsSeparatedByString("rating-qualifier\">")[1].componentsSeparatedByString("<")[0]
            var price: String = arrIndex.componentsSeparatedByString("price-range\">")[1].componentsSeparatedByString("<")[0]
            // If there are multiple types, this method only picks up the first.
            var type: String = arrIndex.componentsSeparatedByString("category-str-list\">")[1].componentsSeparatedByString(">")[1].componentsSeparatedByString("<")[0]
            var fullAddress: String = arrIndex.componentsSeparatedByString("<address>")[1]
            var address: String = fullAddress.componentsSeparatedByString("<")[0]
            var cityStateZip: String = fullAddress.componentsSeparatedByString(">")[1].componentsSeparatedByString("<")[0]
            var phone: String = arrIndex.componentsSeparatedByString("biz-phone\">")[1].componentsSeparatedByString("<")[0]
            var result: Result = Result(n: name, a: address, csz: cityStateZip, pr: price, s: star, r: reviews, t: type, ph: phone)
            results.append(result)
        }
        return results
    }
}