//
//  Teams.swift
//  HockeyTweetSwift
//
//  Created by Mark Thistle on 2014-07-13.
//  Copyright (c) 2014 Test. All rights reserved.
//

import Foundation

class Teams: NSObject {
    let teamTLA = [
        "NJD",
        "NYI",
        "NYR",
        "PHI",
        "PIT",
        "BOS",
        "BUF",
        "MTL",
        "OTT",
        "TOR",
        "ATL",
        "CAR",
        "FLA",
        "TBL",
        "WSH",
        "CHI",
        "CBJ",
        "DET",
        "NSH",
        "STL",
        "CGY",
        "COL",
        "EDM",
        "MIN",
        "VAN",
        "ANA",
        "DAL",
        "LAK",
        "PHX",
        "SJS"]
    
    let teamNames = [
        "New Jersey Devils",
        "New York Islanders",
        "New York Rangers",
        "Philadelphia Flyers",
        "Pittsburgh Penguins",
        "Boston Bruins",
        "Buffalo Sabres",
        "Montreal Canadiens",
        "Ottawa Senators",
        "Toronto Maple Leafs",
        "Atlanta Thrashers",
        "Carolina Hurricanes",
        "Florida Panthers",
        "Tampa Bay Lightning",
        "Washington Capitals",
        "Chicago Blackhawks",
        "Columbus Blue Jackets",
        "Detroit Red Wings",
        "Nashville Predators",
        "St Louis Blues",
        "Calgary Flames",
        "Colorado Avalanche",
        "Edmonton Oilers",
        "Minnesota Wild",
        "Vancouver Canucks",
        "Anaheim Ducks",
        "Dallas Stars",
        "Los Angeles Kings",
        "Phoenix Coyotes",
        "San Jose Sharks"]
    
    // Initialize an empty dictionary so we have a starting point from which to
    // add values in the init call.
    var rosters = [String: Array<String>]()
    
    init() {
        teamNames = sorted(teamNames, { s1, s2 in return s1 < s2 })
        teamTLA = sorted(teamTLA, { s1, s2 in return s1 < s2 })
        // TODO: Ok, need to convert from NS to Swift here
        //        var rostersLoaded = true
        //        if let path: String = NSBundle.mainBundle().pathForResource("players", ofType: "plist") {
        //            let teams = NSDictionary(contentsOfFile: path)
        //            //rosters = rostersFromTeams(teams["players"] as NSDictionary)
        //        } else {
        //            rostersLoaded = false
        //        }
        //        if !rostersLoaded {
        for team in teamTLA {
            rosters[team] = ["--"]
        }
        //}
        super.init()
    }
    
    func playersOnTeam(team: String) -> Array<String>! {
        //if let players: NSDictionary = rosters["players"] as? NSDictionary {
        //    let ns_team: NSString = NSString(string: team)
        //for teamPlayers in players.objectForKey(ns_team) {
        
        //}
        //return nil
        //}
        return nil
    }
    
    func rostersFromTeams(teams: NSDictionary) -> Dictionary<String, Array<String>>! {
        var tmprosters: Dictionary<String, Array<String>>
        for team in teamTLA {
            
        }
        return nil
    }

}