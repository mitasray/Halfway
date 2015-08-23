//
//  FriendsController.swift
//  Halfway
//
//  Created by Kevin Arifin on 7/9/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

protocol FriendsControllerDelegate {
    func createEventWithFriends(friends: [User])
}

class FriendsController: UITableViewController {
    var delegate: FriendsControllerDelegate? = nil
    var invitedFriends = [User]()

    func listOfAllFriends() -> List<User> {
        return logged_in_user().friends
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true;
        
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            if delegate != nil {
                delegate?.createEventWithFriends(invitedFriends)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAllFriends().count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var friend_username = listOfAllFriends()[indexPath.row].username
        
        cell.textLabel?.text = friend_username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        var friend = self.listOfAllFriends()[indexPath.row]
        invite(friend)
    }
    
    private func invite(friend: User) {
        invitedFriends.append(friend)
    }
    
    private func logged_in_user() -> User {
        let realm = Realm()
        return realm.objects(User).first!
    }
}