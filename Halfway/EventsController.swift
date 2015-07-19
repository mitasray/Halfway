//
//  EventsController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/17/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit

public class EventController: UIViewController, FriendsControllerDelegate, YelpSearchOptionsDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var yelpLocationNameLabel: UILabel!
    @IBOutlet weak var yelpResultAddressButton: UIButton!
    @IBOutlet weak var yelpSearchOption: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func createEventWithFriend(friend: User) {
        friendLabel.text =  friend.username
    }
    
    public func setSearchOption(string: String) {
        yelpSearchOption.setTitle(string + " >", forState: UIControlState.Normal)
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inviteFriendToEvent" {
            let friendsController = segue.destinationViewController as! FriendsController
            friendsController.delegate = self
        }
        if segue.identifier == "viewSearchOptions" {
            let yelpSearchOptionsController = segue.destinationViewController as! YelpSearchOptionsController
            yelpSearchOptionsController.delegate = self
        }
    }
    @IBAction func logOut(sender: AnyObject) -> Void {
        for key in defaults.dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
        resetFields()
    }
    
    private func resetFields() -> Void {
        addressField.text = ""
        cityField.text = ""
        stateField.text = ""
        yelpLocationNameLabel.text = ""
        yelpResultAddressButton.setTitle("", forState: UIControlState())
    }
}
