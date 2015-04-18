//
//  TeamPicker.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

class TeamPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    let team: Teams
    // When we switch views we need to keep the last selected row when this view
    // was active. We also want to start in the middle when we select a picker.
    //var selectedTeamRow: Int
    //var selectedPlayerRow: Int
    
    override init() {
        team = Teams()
        //selectedTeamRow = team.teamTLA.count / 2
        //selectedPlayerRow = team.playersOnTeam(team.teamTLA[selectedTeamRow]).count / 2
        super.init()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch (component) {
            case 0:
                return team.teamNames.count
            case 1:
                if let players = team.rosters[team.teamTLA[pickerView.selectedRowInComponent(0)]] {
                    return players.count
                } else {
                    return 0
                }
            default:
                return 0
        }
    }

    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView) -> UIView {
        var rowText: String
        switch (component) {
        case 0:
            rowText = team.teamNames[row]
        case 1:
            if let players = team.playersOnTeam(team.teamTLA[pickerView.selectedRowInComponent(0)]) {
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
        var rowLabel = UILabel(frame: CGRectMake(0.0, 0.0, pickerView.rowSizeForComponent(component).width, pickerView.rowSizeForComponent(component).height))
        rowLabel.text = rowText
        rowLabel.font = UIFont.systemFontOfSize(12.0)
        return rowLabel;
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

    }

}