//
//  PickerButtonViewController.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 2014-07-13.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

protocol PickerButtonBarDelegate {
    func didPressInsertButton()
}

class PickerButtonViewController: UIViewController {
    
    var delegate: PickerButtonBarDelegate?

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSLog("Danger Will Robinson - Low Memory Detected");
    }
    
    @IBAction func didPressInsertButton(sender: UIButton) {
        delegate?.didPressInsertButton()
    }
}