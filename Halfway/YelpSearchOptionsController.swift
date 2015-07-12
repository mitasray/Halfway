//
//  YelpSearchOptionsController.swift
//  Halfway
//
//  Created by Mitas Ray on 7/9/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit

public class YelpSearchOptionsController: UITableViewController, DetailsDelegate {
    
    var options: [String] = ["Restaurant", "Coffee", "Bar", "Park", "Mall"]
    var selected: String = "Restaurant"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var option: String = options[indexPath.row]
        cell.textLabel?.text = option
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        selected = options[indexPath.row]
    }
    
    /**
     * http://stackoverflow.com/questions/25204255/access-the-instance-of-a-viewcontroller-from-another-in-swift
     */
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let controller = segue.destinationViewController as! ViewController
        
    }
    
}