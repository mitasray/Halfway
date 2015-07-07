//
//  SignupController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/4/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

public class SignupController: UIViewController {
    
    let url = "http://halfway-db.herokuapp.com/v1/signup"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var confirm: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBAction func signup(sender: AnyObject) {
        let parameters = [
            "username": username.text,
            "email": email.text,
            "password": password.text,
            "password_confirmation": confirm.text,
        ]
        request(.POST, self.url, parameters: parameters).responseJSON { (req, res, json, error) in
            var json = JSON(json!)
            println(json)
            var id = String(stringInterpolationSegment: json["id"])
            if id == "null" {
                println("error")
            }
            else {
                NSLog("Success: \(self.url)")
                var username = String(stringInterpolationSegment: json["username"])
                self.defaults.setObject(username, forKey: "username")
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
}