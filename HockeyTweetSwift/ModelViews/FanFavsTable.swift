//
//  FanFavsTable.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 4/17/15.
//  Copyright (c) 2015 Test. All rights reserved.
//

import UIKit

class FanFavsTable: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // Mark - UITableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FanFavs().fanFavs.count+1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row <= FanFavs().fanFavs.count-2) {
            if let cell: AnyObject = tableView.dequeueReusableCellWithIdentifier("fanFavCell") {
              cell.textLabel??.text = FanFavs().fanFavs[indexPath.row]
              return cell as! UITableViewCell
            }
        } else {
            if let cell: AnyObject = tableView.dequeueReusableCellWithIdentifier("addFanFavCell") {
                // TODO: Add callback to handle adding a new fanfav
                return cell as! UITableViewCell
            }
        }
        return tableView.dequeueReusableCellWithIdentifier("addFanFavCell") as! UITableViewCell;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
}
