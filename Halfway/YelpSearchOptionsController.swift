//
//  YelpSearchOptionsController.swift
//  Halfway
//
//  Created by Mitas Ray on 7/9/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit

public class YelpSearchOptionsController: UITableViewController {
    
    var options: [String] = ["Restaurant", "Coffee", "Bar", "Park", "Mall"]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var option: String = options[indexPath.row]
        cell.textLabel?.text = option
        return cell
    }
}