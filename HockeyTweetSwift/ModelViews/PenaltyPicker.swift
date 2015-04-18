//
//  PenaltyPicker.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/6/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

class PenaltyPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
                            
    let penalty: [String]
    // When we switch views we need to keep the last selected row when this view
    // was active. We also want to start in the middle when we select a picker.
    var selectedRow: Int
    
    override init()  {
        penalty = Penalties().penalties
        selectedRow = penalty.count / 2
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return penalty.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return penalty[row]
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }

}

