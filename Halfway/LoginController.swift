//
//  LoginController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/4/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

public class LoginController: UIViewController {
    
    let invalidLoginMessage = "translation missing: en.sessions_controller.invalid_login_attempt"
    let url = "http://halfway-db.heroku/v1/login"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        let parameters = [
            "username": username.text,
            "password": password.text,
        ]
        request(.POST, self.url, parameters: parameters).responseJSON { (req, res, json, error) in
            var json = JSON(json!)
            var errorMessage = String(stringInterpolationSegment: json["error"])
            if errorMessage == self.invalidLoginMessage {
                println(self.invalidLoginMessage)
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