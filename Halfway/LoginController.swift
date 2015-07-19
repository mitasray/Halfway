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
    
    let url = "http://halfway-db.herokuapp.com/v1/login"
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        let parameters = [
            "username": username.text,
            "password": password.text,
        ]
        request(.POST, self.url, parameters: parameters).validate().responseJSON { (req, res, json, error) in
            var json = JSON(json!)
            println(json)
            var errorMessage = String(stringInterpolationSegment: json["error"])
            println(errorMessage)
            if errorMessage == "translation missing: en.sessions_controller.invalid_login_attempt" {
                println("invalid")
            }
            else {
                NSLog("Success: \(self.url)")
                var user_id = String(stringInterpolationSegment: json["id"])
                var username = String(stringInterpolationSegment: json["username"])
                var access_token = String(stringInterpolationSegment: json["access_token"])
                
                self.defaults.setObject(username, forKey: "username")
                self.defaults.setObject(user_id, forKey: "user_id")
                self.defaults.setObject(access_token, forKey: "access_token")
                var MainNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("event") as! UIViewController
                self.navigationController?.pushViewController(MainNavigationController, animated: true)
            }
        }
    }
}