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
    public var results = [Result]()
    
    /**
     * Class containing name, address, price, star, reviews, type.
     * All data from single search result stored here.
     */
    public class Result {
        public var name: String
        public var address: String
        public var cityStateZip: String
        public var price: String
        public var star: String
        public var reviews: String
        public var type: String
        public var phone: String
        
        public init(n: String, a: String, csz: String, pr: String, s: String, r: String, t: String, ph: String) {
            name = n
            address = a
            cityStateZip = csz
            price = pr
            star = s
            reviews = r
            type = t
            phone = ph
        }
    }

    public init(halfwayLocation: CLLocation) {
        // Parts of the following code are largely based on http://stackoverflow.com/questions/27495328/reverse-geocode-location-in-swift
        CLGeocoder().reverseGeocodeLocation(halfwayLocation, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = (placemarks[0] as! CLPlacemark).addressDictionary
                var addressString: String = (pm["Street"] as! String) + "%2C" + (pm["City"] as! String) + "%2C" + (pm["State"] as! String)
                
                // The following code is largely based on https://www.yelp.com/developers/documentation/v2/iphone
                var yelpString = "search?find_desc=Restaurants&find_loc="
                addressString = addressString.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
                yelpString = "http://yelp.com/" + yelpString + addressString + "&ns=1"
                var HTML = HTMLGetter(url: yelpString)
                var HTMLString = HTML.getHTML();
                var arr = HTMLString.componentsSeparatedByString("<span class = \"indexed-biz-name\">")
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
                    results.append(Result(n: name, a: address, csz: cityStateZip, pr: price, s: star, r: reviews, t: type, ph: phone))
                }
                
            }
            else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    public func getResults() -> [Result] {
        return results
    }
}