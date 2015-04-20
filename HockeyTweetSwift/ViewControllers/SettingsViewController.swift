//
//  SettingsViewController.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 4/17/15.
//  Copyright (c) 2015 Test. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var tableView : UITableView?
    var tableViewDelegate   : FanFavsTable

    required init(coder aDecoder: NSCoder) {
        tableViewDelegate = FanFavsTable()
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tableView = tableView {
            tableView.dataSource = tableViewDelegate
            tableView.delegate   = tableViewDelegate
        }
    }

    @IBAction func unwindToSettingsView(sender: UIStoryboardSegue) {
        // Pull any data from the view controller which initiated the unwind segue.
    }
}