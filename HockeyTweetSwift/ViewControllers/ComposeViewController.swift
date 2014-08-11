//
//  ComposeViewController.swift
//  SwiftTest
//
//  Created by Mark Thistle on 7/7/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

import UIKit
import Social

enum ShareResult {
    case ShareSuccess, ShareErrUnknown, ShareAccountError, ShareNetworkError, ShareCancelled
    
    func description() -> String {
        switch self {
        case .ShareSuccess:
            return "Share Success"
        case .ShareErrUnknown:
            return "Share Error Unknown"
        case .ShareAccountError:
            return "Share Account Error"
        case .ShareNetworkError:
            return "Share Network Error"
        case .ShareCancelled:
            return "Share Cancelled"
        }
    }
}

class ComposeViewController: UIViewController, ActionStripSelection, UITextViewDelegate, PickerButtonBarDelegate {

    @IBOutlet var actionStripContainer     : UIView?
    @IBOutlet var pickerView               : UIPickerView?
    @IBOutlet var textView                 : UITextView?
    @IBOutlet var charactersRemainingLabel : UILabel?
    @IBOutlet var shareButton              : UIButton?
    
    var penaltyPicker : PenaltyPicker
    var teamPicker    : TeamPicker
    var arenaPicker   : ArenaPicker
    var fanfavPicker  : FanFavsPicker
    
    let maxChars             : Int = 140
    var currentPickerText    : String
    var currentCommittedText : String
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        penaltyPicker = PenaltyPicker()
        teamPicker = TeamPicker()
        arenaPicker = ArenaPicker()
        fanfavPicker = FanFavsPicker()
        currentPickerText = ""
        currentCommittedText = ""
        textView!.text = ""
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder!) {
        penaltyPicker = PenaltyPicker()
        teamPicker = TeamPicker()
        arenaPicker = ArenaPicker()
        fanfavPicker = FanFavsPicker()
        currentPickerText = ""
        currentCommittedText = ""
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.didPressPenalitesButton()
        textView!.delegate = self
        textView!.text = ""
        // Let's round the corners of our UITextView
        textView!.layer.cornerRadius = 8.0
        textView!.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        NSLog("Danger Will Robinson - Low Memory Detected");
    }

    func didPressTeamsButton() {
        pickerView!.dataSource = teamPicker
        pickerView!.delegate = teamPicker
        pickerView!.reloadAllComponents()
        textView!.resignFirstResponder()
    }

    func didPressArenasButton() {
        pickerView!.dataSource = arenaPicker
        pickerView!.delegate = arenaPicker
        pickerView!.selectRow(arenaPicker.selectedRow, inComponent: 0, animated: false)
        pickerView!.reloadAllComponents()
        textView!.resignFirstResponder()
    }

    func didPressFanFavsButton() {
        pickerView!.dataSource = fanfavPicker
        pickerView!.delegate = fanfavPicker
        pickerView!.selectRow(fanfavPicker.selectedRow, inComponent: 0, animated: false)
        pickerView!.reloadAllComponents()
        textView!.resignFirstResponder()
    }

    func didPressPenalitesButton() {
        pickerView!.dataSource = penaltyPicker
        pickerView!.delegate = penaltyPicker
        pickerView!.selectRow(penaltyPicker.selectedRow, inComponent: 0, animated: false)
        pickerView!.reloadAllComponents()
        textView!.resignFirstResponder()
   }
    
    func didPressInsertButton() {
        var textToAdd: String
        
        if pickerView!.numberOfComponents == 1 {
            textToAdd = pickerView!.delegate.pickerView!(pickerView, titleForRow: pickerView!.selectedRowInComponent(0), forComponent: 0)
        } else if pickerView!.numberOfComponents == 2 {
            textToAdd = pickerView!.delegate.pickerView!(pickerView!, titleForRow: pickerView!.selectedRowInComponent(1), forComponent: 1)
        } else {
            NSLog("Unrecognized picker with number of components = \(pickerView!.numberOfComponents)")
            textToAdd = "--"
        }
        if let currentText = textView!.text {
            textView!.text = "\(currentText) \(textToAdd)"
        }
        let charsUsed = maxChars - countElements(textView!.text!)
        charactersRemainingLabel!.text = "\(charsUsed)"
        if charsUsed < 0 {
            charactersRemainingLabel!.textColor = UIColor.redColor()
        } else {
            charactersRemainingLabel!.textColor = UIColor.blackColor()
        }
    }

    @IBAction func didPressShareButton() {
        // From: https://dev.twitter.com/docs/ios/using-tweet-sheet
        //  Create an instance of the Tweet Sheet
        var tweetSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        
        // Sets the completion handler.  Note that we don't know which thread the
        // block will be called on, so we need to ensure that any required UI
        // updates occur on the main queue
        tweetSheet.completionHandler = ({
            switch($0) {
                //  This means the user cancelled without sending the Tweet
            case .Cancelled:
                self.didDismissShareDialog(ShareResult.ShareCancelled)
                //  This means the user hit 'Send'
            case .Done:
                self.didDismissShareDialog(ShareResult.ShareSuccess)
            }
        })
        
        //  Set the initial body of the Tweet
        tweetSheet.setInitialText(textView!.text)
        
        //  Presents the Tweet Sheet to the user
        self.presentViewController(tweetSheet, animated: true, completion: ({
            }))
    }

    func didDismissShareDialog(shareResult: ShareResult) {
        // TODO: Bug here if the user tries to share and no Twitter account is setup. This method gets called from didPressButton completionHandler with ShareSuccess even when the completionHandler got a result of Canceclled.
        switch (shareResult) {
        case .ShareSuccess:
            NSLog(shareResult.description())
        default:
            textView!.text = ""
            charactersRemainingLabel!.text = "\(maxChars)"
            charactersRemainingLabel!.textColor = UIColor.blackColor()
        }
        
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
        charactersRemainingLabel!.text = "\(maxChars)"
        charactersRemainingLabel!.textColor = UIColor.blackColor()
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if let segueName = segue.identifier {
            if "embedActionStripSegue" == segueName {
                let asvc: ActionStripViewController = segue.destinationViewController as ActionStripViewController
                asvc.delegate = self
            } else if "pickerButtonBarSegue" == segueName {
                let pbvc: PickerButtonViewController = segue.destinationViewController as PickerButtonViewController
                pbvc.delegate = self
            }
        }
    }
    
}