//
//  ViewController.swift
//  Halfway
//
//  Created by Mitas Ray on 6/3/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
// Map Tutorial: http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial

class ViewController: UIViewController {
    
    @IBOutlet var address : UITextField!
    @IBOutlet var city : UITextField!
    @IBOutlet var state : UITextField!
    
    @IBAction func donePressed(sender: AnyObject) {
        var fullAddress = address.text + " " + city.text + " " + state.text
        // println(fullAddress)
        findLatLong(fullAddress)
    }
    
    /**
     * http://stackoverflow.com/questions/26134884/how-to-get-html-source-from-url-with-swift
     * Returns the HTML source code of the geocoder.us webpage with the proper address.
     */
    func getHTML(fullAddress : String) -> NSString {
        var urlAddress = fullAddress.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let myURLString = "http://geocoder.us/demo.cgi?address=" + urlAddress
        
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                println("Error : \(error)")
            } else {
                println("HTML : \(myHTMLString)")
                return myHTMLString!
            }
        } else {
            println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
        return NSString(string: "")
    }
    
    func findLatLong(fullAddress : String) {
        var HTMLString = getHTML(fullAddress)
        
    }
    
    @IBAction func viewTapped(sender: AnyObject) {
        // Empty.
    }
    
    // Getting HTML source code from url: http://stackoverflow.com/questions/26134884/how-to-get-html-source-from-url-with-swift
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

