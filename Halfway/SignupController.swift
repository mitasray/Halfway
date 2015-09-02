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
import RealmSwift
import CoreLocation

class SignupController: UIViewController, CLLocationManagerDelegate {
    
    let url = "http://halfway-db.herokuapp.com/v1/signup"
    let defaults = NSUserDefaults.standardUserDefaults()
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    @IBAction func signup(sender: AnyObject) {
        let parameters = [
            "username": usernameField.text,
            "email": emailField.text,
            "password": passwordField.text,
            "password_confirmation": confirmPasswordField.text,
        ]
        request(.POST, self.url, parameters: parameters).validate().responseJSON { (request, response, json, error) in
            var new_user_attributes = json as! Dictionary<String, AnyObject>
            
            new_user_attributes["latitude"] = self.locationManager.location.coordinate.latitude
            new_user_attributes["longitude"] = self.locationManager.location.coordinate.longitude
            var logged_in_user = User(value: new_user_attributes)
            
            let realm = Realm()
            realm.write { realm.add(logged_in_user) }
            
            var MainNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("event") as! UIViewController
            self.navigationController?.pushViewController(MainNavigationController, animated: true)
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
