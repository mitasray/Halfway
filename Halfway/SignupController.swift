
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
import RealmSwift
import CoreLocation
import SVProgressHUD

class SignupController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func signup(sender: AnyObject) {
        let alert = UIAlertView()
        if emailField.text!.isEmpty {
            alert.title = "Please Enter a Email"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        } else if usernameField.text!.isEmpty {
            alert.title = "Please Enter a Username"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        } else if passwordField.text!.isEmpty {
            alert.title = "Please Enter a Password"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        } else if confirmPasswordField.text!.isEmpty {
            alert.title = "Please Confirm your Password"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
        let signup_url = "https://halfway-db.herokuapp.com/v1/signup"
        let parameters = [
            "username": usernameField.text!,
            "email": emailField.text!,
            "password": passwordField.text!,
            "password_confirmation": confirmPasswordField.text!,
            "latitude": String(stringInterpolationSegment: locationManager.location!.coordinate.latitude),
            "longitude": String(stringInterpolationSegment: locationManager.location!.coordinate.longitude),
        ]
        SVProgressHUD.show()
        request(.POST, signup_url, parameters: parameters).validate().responseJSON { response in
            let json = response.result.value
            var new_user_attributes = json as! Dictionary<String, AnyObject>
            
            new_user_attributes["latitude"] = new_user_attributes["latitude"]!.doubleValue
            new_user_attributes["longitude"] = new_user_attributes["longitude"]!.doubleValue
            
            let logged_in_user = User(value: new_user_attributes)
            
            let realm = try! Realm()
            try! realm.write { realm.add(logged_in_user) }
            
            var MainNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("event") as? UIViewController!
            self.performSegueWithIdentifier("signup", sender: self)
            SVProgressHUD.dismiss()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
}
