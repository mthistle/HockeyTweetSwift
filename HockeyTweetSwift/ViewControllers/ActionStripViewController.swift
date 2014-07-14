//
//  ActionStripViewController.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

protocol ActionStripSelection {
    func didPressTeamsButton()
    func didPressArenasButton()
    func didPressFanFavsButton()
    func didPressPenalitesButton()
}

class ActionStripViewController: UIViewController {

    var delegate: ActionStripSelection?
    @IBOutlet var teamsButton: UIButton
    @IBOutlet var arenasButton: UIButton
    @IBOutlet var fanFavsButton: UIButton
    @IBOutlet var penaltiessButton: UIButton

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSLog("Danger Will Robinson - Low Memory Detected");
    }
    
    
    @IBAction func didPressTeamsButton(sender: UIButton) {
        NSLog("Teams Button")
        delegate?.didPressTeamsButton()
    }

    @IBAction func didPressArenasButton(sender: UIButton) {
        NSLog("Arenas Button")
        delegate?.didPressArenasButton()
    }

    @IBAction func didPressFanFavsButton(sender: UIButton) {
        NSLog("FanFavs Button")
        delegate?.didPressFanFavsButton()
    }

    @IBAction func didPressPenaltiesButton(sender: UIButton) {
        NSLog("Penalties Button")
        delegate?.didPressPenalitesButton()
    }

}
