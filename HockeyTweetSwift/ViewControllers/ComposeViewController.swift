//
//  ComposeViewController.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/7/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit

protocol ComposeViewProtocol {
    // Called when a user selects a text item from the picker
    func didAddText(textToAdd: String)
}

class ComposeViewController: UIViewController, ActionStripSelection, UITextViewDelegate, ComposeViewProtocol {

    @IBOutlet var actionStripContainer     : UIView
    @IBOutlet var pickerView               : UIPickerView
    @IBOutlet var textView                 : UITextView
    @IBOutlet var charactersRemainingLabel : UILabel
    
    var penalties : PenaltyPicker
    var teams     : TeamPicker
    var arenas    : ArenaPicker
    var fanfavs   : FanFavsPicker
    
    let maxChars  : Int = 140
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.penalties = PenaltyPicker()
        self.teams = TeamPicker()
        self.arenas = ArenaPicker()
        self.fanfavs = FanFavsPicker()
        super.init(nibName: nil, bundle: nil)
    }
    
    init(coder aDecoder: NSCoder!) {
        self.penalties = PenaltyPicker()
        self.teams = TeamPicker()
        self.arenas = ArenaPicker()
        self.fanfavs = FanFavsPicker()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pickerView.dataSource = self.penalties
        self.pickerView.delegate = self.penalties
        self.pickerView.reloadAllComponents()
        self.textView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didPressTeamsButton() {
        self.pickerView.dataSource = self.teams
        self.pickerView.delegate = self.teams
        self.pickerView.reloadAllComponents()
        self.textView.resignFirstResponder()
    }

    func didPressArenasButton() {
        self.pickerView.dataSource = self.arenas
        self.pickerView.delegate = self.arenas
        self.pickerView.reloadAllComponents()
        self.textView.resignFirstResponder()
    }

    func didPressFanFavsButton() {
        self.pickerView.dataSource = self.fanfavs
        self.pickerView.delegate = self.fanfavs
        self.pickerView.reloadAllComponents()
        self.textView.resignFirstResponder()
    }

    func didPressPenalitesButton() {
        self.pickerView.dataSource = self.penalties
        self.pickerView.delegate = self.penalties
        self.pickerView.reloadAllComponents()
        self.textView.resignFirstResponder()
   }

    func willPresentShareDialog() {

    }

    func didDismissShareDialog(shareResult: ShareResult) {
        switch (shareResult) {
        case .ShareSuccess:
            NSLog("\(shareResult)")
        default:
            textView.text = ""
            charactersRemainingLabel.text = "140"
            // TODO: can I used atrributed test to change the ciolor?
        }
        
    }
    
    func didAddText(textToAdd: String) {
        if let currentText = textView.text {
            textView.text = "\(currentText) \(textToAdd)"
        }
        // TODO: Update char remaining count
        // TODO: can I used atrributed test to change the ciolor?
    }
    
    // called when 'return' key pressed
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        return true
    }
    
    // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        return true
    }
    
    //func textFieldDidBeginEditing(textField: UITextField!) // became first responder
    //func textFieldDidEndEditing(textField: UITextField!) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    // return NO to not change text
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        return true
    }
    
    // called when clear button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(textField: UITextField!) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let segueName = segue.identifier {
            if "embedActionStripSegue" == segueName {
                let asvc: ActionStripViewController = segue.destinationViewController as ActionStripViewController
                asvc.delegate = self
            }
        }
    }
    
}