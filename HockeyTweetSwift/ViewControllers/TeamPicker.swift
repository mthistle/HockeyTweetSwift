//
//  TeamPicker.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

class TeamPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

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
    
    func rostersFromTeams(teams: NSDictionary) -> Dictionary<String, Array<String>>! {
        var tmprosters: Dictionary<String, Array<String>>
        for team in teamTLA {
            
        }
        return nil
    }
        
    func rosterForTeam(team: String) -> Array<String>! {
        //if let players: NSDictionary = rosters["players"] as? NSDictionary {
        //    let ns_team: NSString = NSString(string: team)
            //for teamPlayers in players.objectForKey(ns_team) {

            //}
            //return nil
        //}
        return nil
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
            case 0:
                return teamNames.count
            case 1:
                if let players = rosters[teamTLA[pickerView.selectedRowInComponent(0)]] {
                    return players.count
                } else {
                    return 0
                }
            default:
                return 0
        }
    }


    // returns width of column and height of row for each component.
    //func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat
    //func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat

    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    // func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {


    //func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! // attributed title is favored if both methods are implemented
    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
        var rowText: String
        switch (component) {
        case 0:
            rowText = teamNames[row]
        case 1:
            if let players = rosters[teamTLA[pickerView.selectedRowInComponent(0)]] {
                rowText = players[row]
            } else {
                rowText = "--"
            }
        default:
            rowText =  "--"
        }
        var frame = CGRect()
        // TODO: center rows by calculating size of font and then centering that
        //frame.
        var rowLabel = UILabel(frame: CGRectMake(0.0, 0.0, pickerView!.rowSizeForComponent(component).width, pickerView!.rowSizeForComponent(component).height))
        rowLabel.text = rowText
        rowLabel.font = UIFont.systemFontOfSize(12.0)
        return rowLabel;
    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        
    }

}