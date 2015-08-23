//
//  MenuController.swift
//  Halfway
//
//  Created by Kevin Arifin on 8/23/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class MenuController: UITableViewController {
    
    @IBOutlet weak var logoutCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutCell.textLabel!.text = "Logout"
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        var selectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if selectedCell?.textLabel?.text as String! == "Logout"  {
            let realm = Realm()
            realm.write {
                realm.deleteAll()
            }
        }
        self.performSegueWithIdentifier("logout", sender: self)
    }
}