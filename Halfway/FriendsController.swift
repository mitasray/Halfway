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
    func createEventWithFriend(friend: User)
}

public class FriendsController: UITableViewController {
    var delegate: FriendsControllerDelegate? = nil

    public func listOfAllFriends() -> List<User> {
        return logged_in_user().friends
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
        if delegate != nil {
            delegate?.createEventWithFriend(friend)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    private func logged_in_user() -> User {
        let realm = Realm()
        return realm.objects(User).first!
    }
}