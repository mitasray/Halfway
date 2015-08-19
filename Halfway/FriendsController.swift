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
import SwiftyJSON
import RealmSwift

protocol FriendsControllerDelegate {
    func createEventWithFriends(friends: [User])
}

public class FriendsController: UITableViewController {
    var delegate: FriendsControllerDelegate? = nil
    var invitedFriends = [User]()

    public func listOfAllFriends() -> List<User> {
        return logged_in_user().friends
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelection = true;
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfAllFriends().count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        var friend_username = listOfAllFriends()[indexPath.row].username
        
        cell.textLabel?.text = friend_username
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }

    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        var friend = self.listOfAllFriends()[indexPath.row]
        invite(friend)
    }
    
    @IBAction func inviteSelectedFriends(sender: AnyObject) {
        if delegate != nil {
            delegate?.createEventWithFriends(invitedFriends)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    private func invite(friend: User) {
        invitedFriends.append(friend)
    }
    
    private func logged_in_user() -> User {
        let realm = Realm()
        return realm.objects(User).first!
    }
}