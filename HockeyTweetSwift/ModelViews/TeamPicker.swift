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

    init() {
        team = Teams()
        super.init()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 2
    }

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
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
            rowText = team.teamNames[row]
        case 1:
            if let players = team.rosters[team.teamTLA[pickerView.selectedRowInComponent(0)]] {
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