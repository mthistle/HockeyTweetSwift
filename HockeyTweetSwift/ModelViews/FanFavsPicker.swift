//
//  FanFavsPicker.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

class FanFavsPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

    let fanFavShortcuts: [String]
    // When we switch views we need to keep the last selected row when this view
    // was active. We also want to start in the middle when we select a picker.
    var selectedRow: Int
    
    override init() {
        fanFavShortcuts = FanFavs().fanFavs
        selectedRow = fanFavShortcuts.count / 2
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return fanFavShortcuts.count
    }


    // returns width of column and height of row for each component.
    //func pickerView(pickerView: UIPickerView!, widthForComponent component: Int) -> CGFloat
    //func pickerView(pickerView: UIPickerView!, rowHeightForComponent component: Int) -> CGFloat

    // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
    // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
    // If you return back a different object, the old one will be released. the view will be centered in the row rect
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return fanFavShortcuts[row]
    }

    //func pickerView(pickerView: UIPickerView!, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString! // attributed title is favored if both methods are implemented
//    func pickerView(pickerView: UIPickerView!, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView! {
//        var rowLabel = UILabel()
//        var rowText = fanFavShortcuts[row]
//        rowLabel.text = rowText
//        rowLabel.font = UIFont.systemFontOfSize(12.0)
//        return rowLabel;
//    }

    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }

}
