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
import RealmSwift

class LoginController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        let login_user_url = "http://halfway-db.herokuapp.com/v1/login"

        let parameters = [
            "username": usernameField.text,
            "password": passwordField.text,
        ]
        request(.POST, login_user_url, parameters: parameters).validate().responseJSON { (request, response, json, error) in
            var user_attributes = json as! NSDictionary
            var logged_in_user = User(value: user_attributes)
            self.fetch_user_data(logged_in_user)
            
            let realm = Realm()
            realm.write { realm.add(logged_in_user) }
            logged_in_user = realm.objects(User).filter("id = \(logged_in_user.id)").first!

            var MainNavigationController = self.storyboard?.instantiateViewControllerWithIdentifier("event") as! UIViewController
            self.performSegueWithIdentifier("login", sender: self)
        }
    }
    
    private func fetch_user_data(logged_in_user: User) {
        load_user_friends(logged_in_user)
        load_user_events(logged_in_user)
    }
    
    private func load_user_friends(logged_in_user: User) {
        let friendships_index_url = "http://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user.id) + "/friendships"
        let realm = Realm()
        request(.GET, friendships_index_url).responseJSON { (request, response, json, error) in
            for friend in json as! NSArray {
                var friend_attributes = friend as! NSDictionary
                var friend = User(value: friend_attributes)
                realm.write {
                    logged_in_user.friends.append(friend)
                }
            }
        }
    }
    
    private func load_user_events(logged_in_user: User) {
        let user_events_index_url = "http://halfway-db.herokuapp.com/v1/users/" + String(logged_in_user.id) + "/events"
        let realm = Realm()
        request(.GET, user_events_index_url).responseJSON { (request, response, json, error) in
            println(json)
            for event in json as! NSArray {
                var event_attributes = event as! Dictionary<String, AnyObject>
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                event_attributes["date"] = dateFormatter.dateFromString(String(stringInterpolationSegment: event_attributes["date"]))
                event_attributes["details"] = event_attributes["description"]
                event_attributes["latitude"] = 0.0
                event_attributes["longitude"] = 0.0
                
                var newEvent = Event(value: event_attributes)
                realm.write {
                    logged_in_user.events.append(newEvent)
                }
            }
        }
    }
}