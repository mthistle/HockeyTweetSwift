//
//  PenaltyPicker.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

class PenaltyPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
                            
    var penalty = [
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

    init()  {
        // Sort array and return new sorted array
        penalty = sorted(penalty, { s1, s2 in return s1 < s2 })
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return penalty.count
    }


    // returns width of column and height of row for each component.
    //func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat
    //func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat

    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return penalty[row]
    }

    //func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! // attributed title is favored if both methods are implemented
    //func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView!

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        
    }

}
