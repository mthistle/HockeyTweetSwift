//
//  Arenas.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 2014-07-13.
//  Copyright (c) 2014 Test. All rights reserved.
//

import Foundation

class Arenas {
    
    var arenas = [String]()
    
    init() {
        if let path: String = NSBundle.mainBundle().pathForResource("Arenas", ofType: "plist") {
            if let teamArray = NSArray(contentsOfFile: path) {
                for team in teamArray {
                    arenas.append(team["Arena"] as! String)
                }
            }
            // Sort array in place
            sort(&arenas, { s1, s2 in return s1.lowercaseString < s2.lowercaseString })
        }
        // Add a no arenas placeholder if none added
        if arenas.isEmpty {
            arenas = [ "No arenas found." ]
        }
    }
}