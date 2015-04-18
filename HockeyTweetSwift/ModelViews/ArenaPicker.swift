//
//  ArenaPicker.swift
//  SwiftTest
//
//  Created by Mark Thistle on 2014-07-09.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

class ArenaPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let arenas: Array<String>
    // When we switch views we need to keep the last selected row when this view
    // was active. We also want to start in the middle when we select a picker.
    var selectedRow: Int
    
    override init() {
        arenas = Arenas().arenas
        selectedRow = arenas.count / 2
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arenas.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return arenas[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
}

