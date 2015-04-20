//
//  AboutViewController.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 4/17/15.
//  Copyright (c) 2015 Test. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        webView.loadHTMLString(self.webViewBody(), baseURL: nil)
//        let buildVersion = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as String
//        let versionNumber = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as String
//        self.versionLabel.text = "Version: \(versionNumber) (\(buildVersion))"
    }

    func webViewBody() -> String {
        let bundle = NSBundle.mainBundle()
        //let pathReachabilityLicense = bundle.pathForResource("Reachability_LICENSE", ofType: "txt")
        //let ReachabilityLicense = String(contentsOfFile: pathReachabilityLicense!, encoding: NSUTF8StringEncoding, error: nil)
        let body = "<html><body><h3>Licenses:</h3><ul><li></li></ul></body></html>"
        return body
    }
}