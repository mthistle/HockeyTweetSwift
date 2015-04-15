//
//  FanFavs.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 2014-07-13.
//  Copyright (c) 2014 Test. All rights reserved.
//

import Foundation

class FanFavs {
    
    var fanFavs: [String]
    
    init() {
        fanFavs = [
            "blueline",
            "breakaway",
            "faceoff",
            "fight",
            "great save",
            "good play",
            "Home Ice",
            "nice pass",
            "nice hit",
            "offside",
            "overtime",
            "penalty",
            "penalty killing",
            "penalty shot",
            "Playoffs",
            "power play",
            "pulled the goalie",
            "Regular Season",
            "shoot the puck",
            "shoots, HE SCORES!!!",
            "shorthanded",
            "Stanley Cup",
            "there's a penalty coming",
            "visitors",
            "wide open net"]
        
        // Sort array in place
        sort(&fanFavs, { s1, s2 in return s1.lowercaseString < s2.lowercaseString })
    }
}