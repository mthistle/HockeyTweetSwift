//
//  Penalties.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 2014-07-13.
//  Copyright (c) 2014 Test. All rights reserved.
//

import Foundation

class Penalties {
    var penalties: [String]
    
    init()  {
        penalties = [
            "Joining A Fight",
            "Abuse Of Officials",
            "Aggressor",
            "Attempt To Injure",
            "Boarding",
            "Butt-Ending",
            "Charging",
            "Checking From Behind",
            "Clipping",
            "Cross Checking",
            "Delay of Game",
            "Diving",
            "Elbowing",
            "Fighting",
            "Goaltender Interference",
            "Hand Pass",
            "Head Butting",
            "High Sticking",
            "Holding",
            "Holding the Stick",
            "Hooking",
            "Icing",
            "Illegal Equipment",
            "Illegal Substitution",
            "Instigator",
            "Interference",
            "Kicking",
            "Kneeing",
            "Penalty Shot",
            "Roughing",
            "Slashing",
            "Slew Footing",
            "Spearing",
            "Starting the Wrong Lineup",
            "Too Many Men on the Ice",
            "Tripping",
            "Unsportsmanlike Conduct",
            "WashOut"]
        
        // Sort array in place
        sort(&penalties, { s1, s2 in return s1 < s2 })
    }
}