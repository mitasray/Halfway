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
import RealmSwift
import SVProgressHUD

class LoginController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        let alert = UIAlertView()
        if usernameField.text!.isEmpty {
            alert.title = "Please Enter Your Username"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        } else if passwordField.text!.isEmpty {
            alert.title = "Please Enter Your Password"
            alert.addButtonWithTitle("Ok")
            alert.show()
            return
        }
        
        let login_user_url = "https://halfway-db.herokuapp.com/v1/login"
        let parameters = [
            "username": usernameField.text!,
            "password": passwordField.text!,
        ]
        SVProgressHUD.show()
        request(.POST, login_user_url, parameters: parameters).validate().responseJSON { response in
            let json = response.result.value
            var user_attributes = json as! Dictionary<String, AnyObject>
            user_attributes["latitude"] = user_attributes["latitude"]!.doubleValue
            user_attributes["longitude"] = user_attributes["longitude"]!.doubleValue
            
            var logged_in_user = User(value: user_attributes)
            self.fetch_user_data(logged_in_user)
            
            let realm = try! Realm()
            try! realm.write { realm.add(logged_in_user) }
            logged_in_user = realm.objects(User).filter("id = \(logged_in_user.id)").first!

            var MainNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("event") as? UIViewController!
            self.performSegueWithIdentifier("login", sender: self)
            SVProgressHUD.dismiss()
        }
    }
    
    private func fetch_user_data(logged_in_user: User) {
        load_all_users(logged_in_user)
        load_user_events(logged_in_user)
        load_user_friends(logged_in_user)
    }
    
    private func load_user_friends(logged_in_user: User) {
        let friendships_index_url = "https://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user.id) + "/friendships"
        let realm = try! Realm()
        let headers = ["Authorization": logged_in_user.access_token]
        request(.GET, friendships_index_url, headers: headers).responseJSON { response in
            let json = response.result.value
            for friend in json as! NSArray {
                var friend_attributes = friend as! Dictionary<String, AnyObject>
                let username = friend_attributes["username"]! as! String
                let predicate = NSPredicate(format: "username = %@", username)
                let friend = realm.objects(User).filter(predicate).first!
                try! realm.write {
                    logged_in_user.friends.append(friend)
                }
            }
        }
    }
    
    private func load_all_users(logged_in_user: User) {
        let users_index_url = "https://halfway-db.herokuapp.com/v1/users/"
        let realm = try! Realm()
        let headers = ["Authorization": logged_in_user.access_token]
        request(.GET, users_index_url, headers: headers).responseJSON { response in
            let json = response.result.value
            for user_attributes in json as! NSArray {
                var user_attributes = user_attributes as! Dictionary<String, AnyObject>
                user_attributes["latitude"] = user_attributes["latitude"]!.doubleValue
                user_attributes["longitude"] = user_attributes["longitude"]!.doubleValue
                let user = User(value: user_attributes)
                if self.user_not_loaded(user) {
                    try! realm.write { realm.add(user) }
                }
            }
        }
    }
    
    private func user_not_loaded(user: User) -> Bool {
        let realm = try! Realm()
        if realm.objects(User).filter("username = %@", user.username).count == 0 {
            return true
        }
        return false
    }
    
    private func load_user_events(logged_in_user: User) {
        let user_events_index_url = "https://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user.id) + "/events"
        let realm = try! Realm()
        let headers = ["Authorization": logged_in_user.access_token]
        request(.GET, user_events_index_url, headers: headers).responseJSON { response in
            let json = response.result.value
            for event in json as! NSArray {
                var event_attributes = event as! Dictionary<String, AnyObject>
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                event_attributes["date"] = dateFormatter.dateFromString(String(stringInterpolationSegment: event_attributes["date"]))
                event_attributes["details"] = event_attributes["description"]
                event_attributes["latitude"] = 0.0
                event_attributes["longitude"] = 0.0
                
                let
                newEvent = Event(value: event_attributes)
                try! realm.write {
                    logged_in_user.events.append(newEvent)
                }
            }
        }
    }
}