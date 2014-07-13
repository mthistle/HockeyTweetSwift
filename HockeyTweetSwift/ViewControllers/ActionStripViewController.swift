//
//  ActionStripViewController.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

enum ShareResult {
    case ShareSuccess, ShareErrUnknown, ShareAccountError, ShareNetworkError, ShareCancelled

    func description() -> String {
        switch self {
        case .ShareSuccess:
            return "Share Success"
        case .ShareErrUnknown:
            return "Share Error Unknown"
        case .ShareAccountError:
            return "Share Account Error"
        case .ShareNetworkError:
            return "Share Network Error"
        case .ShareCancelled:
            return "Share Cancelled"
        }
    }
}

protocol ActionStripSelection {
    func didPressTeamsButton()
    func didPressArenasButton()
    func didPressFanFavsButton()
    func didPressPenalitesButton()
    func willPresentShareDialog()
    func didDismissShareDialog(shareResult: ShareResult)
}

class ActionStripViewController: UIViewController {

    var delegate: ActionStripSelection?
    @IBOutlet var teamsButton: UIButton
    @IBOutlet var arenasButton: UIButton
    @IBOutlet var fanFavsButton: UIButton
    @IBOutlet var penaltiessButton: UIButton
    @IBOutlet var shareButton: UIButton

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPressTeamsButton(sender: UIButton) {
        NSLog("Teams Button")
        self.delegate?.didPressTeamsButton()
    }

    @IBAction func didPressArenasButton(sender: UIButton) {
        NSLog("Arenas Button")
        self.delegate?.didPressArenasButton()
    }

    @IBAction func didPressFanFavsButton(sender: UIButton) {
        NSLog("FanFavs Button")
        self.delegate?.didPressFanFavsButton()
    }

    @IBAction func didPressPenaltiesButton(sender: UIButton) {
        NSLog("Penalties Button")
        self.delegate?.didPressPenalitesButton()
    }

    @IBAction func didPressShareButton(sender: UIButton) {
        NSLog("Share Button")
        self.delegate?.willPresentShareDialog()
        // TODO: Present the share dialog, when it returns fire didDismissShareDialog
    }
}
