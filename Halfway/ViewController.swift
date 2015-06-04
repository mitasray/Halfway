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
        var fullAddress = address.text + ", " + city.text + ", " + state.text
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

