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
    
    // Second string is an integer value indicating a sublevel. Ex: Restaurant > Korean
    var options: [[String]] = [
        ["Food", "0"],
        ["Restaurant", "0"],
        ["Korean", "1"],
        ["Vietname", "1"],
        ["Japanese", "1"],
        ["Indian", "1"],
        ["Chinese", "1"],
        ["Coffee", "0"],
        ["Bar", "0"],
        ["Park", "0"],
        ["Mall", "0"],
        ["Movie", "0"],
    ]
    var selectedOption: String = "Food"
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        var option: String = options[indexPath.row][0]
        
        for _: Int in 0...options[indexPath.row][1].toInt()! {
            option = "    " + option
        }
        option = option.substringFromIndex(advance(option.startIndex, 4))
        
        cell.textLabel?.text = option
        return cell
    }
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) -> Void {
        selectedOption = options[indexPath.row][0]
        if delegate != nil {
            delegate!.setSearchOption(selectedOption)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}