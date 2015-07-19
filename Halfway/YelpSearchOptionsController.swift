//
//  YelpSearchOptionsController.swift
//  Halfway
//
//  Created by Mitas Ray on 7/9/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import Foundation
import UIKit

protocol YelpSearchOptionsDelegate {
    func setSearchOption(string: String)
}

public class YelpSearchOptionsController: UITableViewController {
    
    var delegate: YelpSearchOptionsDelegate! = nil
    
    var options: [String] = ["food", "restaurant", "coffee", "bar", "park", "mall"]
    var selectedOption: String = "restaurant"
    
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
        selectedOption = options[indexPath.row]
        if delegate != nil {
            delegate!.setSearchOption(selectedOption)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}