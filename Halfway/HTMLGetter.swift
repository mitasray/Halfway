//
//  HTMLGetter.swift
//  Halfway
//
//  Created by Mitas Ray on 6/21/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation

public class HTMLGetter {
    
    var fullAddress: String
    
    public init(url: String) {
        self.fullAddress = url.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    /**
    * http://stackoverflow.com/questions/26134884/how-to-get-html-source-from-url-with-swift
    * Returns the HTML source code of the geocoder.us webpage with the proper address.
    */
    public func getHTML() -> NSString {
        if let myURL = NSURL(string: fullAddress) {
            var error: NSError?
            let myHTMLString = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                // println("Error : \(error)")
            } else {
                // println("HTML : \(myHTMLString)")
                return myHTMLString!
            }
        } else {
            // println("Error: \(fullAddress) doesn't seem to be a valid URL")
        }
        return NSString(string: "") // Empty NSString is returned if HTML is not a valid URL
    }
}