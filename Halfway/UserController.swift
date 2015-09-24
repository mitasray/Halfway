//
//  UserController.swift
//  Halfway
//
//  Created by Kevin Arifin on 8/23/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import SWRevealViewController
import RealmSwift

class UserController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var numberOfFriendsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        displayUserInformation()
    }
    
    private func displayUserInformation() {
        usernameLabel.text = logged_in_user().username
        emailLabel.text = logged_in_user().email
        numberOfFriendsLabel.text = String(logged_in_user().friends.count)
    }
    
    private func logged_in_user() -> User {
        let realm = try! Realm()
        return realm.objects(User).first!
    }
}
