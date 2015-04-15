//
//  ComposeViewController.h
//  Call It Hockey
//
//  Created by Mark Thistle on 25/08/09.
//  Copyright 2009 __LockerNine.com__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlipsideViewController.h"
#import "TwitterEngine.h"

@class RoundedRect;

@interface ComposeViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, FlipsideViewControllerDelegate, TwitterEngineDelegate> {
  UITextView     *tweetMsg;
	UIPickerView   *pickerView;
	UINavigationItem *navItem;
	UILabel        *charRemaining;
	
	NSMutableArray *pickerList;
	NSMutableArray *secondaryPickerList;
	NSMutableArray *pickerGames;
	NSArray        *pickerArenas;
	
	BOOL           teamPickerSelected;
	BOOL           penaltyPickerSelected;
	BOOL           gamePickerSelected;
	BOOL           arenaPickerSelected;
	BOOL           customPickerSelected;
	
	NSInteger      lastSelectedPenaltyPickerRow;
	NSInteger      lastSelectedTeamPickerRow;
	NSInteger      lastSelectedPlayerPickerRow;
	NSInteger      lastSelectedGamePickerRow;
	NSInteger      lastSelectedArenaPickerRow;
	NSInteger      lastSelectedCustomPickerRow;
	
	UIButton			 *infoButton;
	
	// A view to handle showing a nicer UI for when we are doing network events
	RoundedRect    *myActivityIndicator;
	
	// Need this to handle OAuth connection to Twitter
	UIViewController *OAuthVC;
}

@property (nonatomic, retain) IBOutlet UITextView   *tweetMsg;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
@property (nonatomic, retain) UILabel *charRemaining;
@property (retain) NSMutableArray       *pickerList;
@property (retain) NSMutableArray       *secondaryPickerList;
@property (retain) NSMutableArray       *pickerGames;
@property (retain) NSArray							*pickerArenas;
@property NSInteger      lastSelectedPenaltyPickerRow;
@property NSInteger      lastSelectedTeamPickerRow;
@property NSInteger      lastSelectedPlayerPickerRow;
@property NSInteger      lastSelectedGamePickerRow;
@property NSInteger			 lastSelectedArenaPickerRow;
@property NSInteger			 lastSelectedCustomPickerRow;
@property (nonatomic, retain) UIButton *infoButton;
@property (nonatomic, retain) RoundedRect *myActivityIndicator;
@property (nonatomic, retain) UIViewController *OAuthVC;

- (IBAction)showInfo;
- (IBAction)sendMsg;
- (IBAction)cancelCompose;
- (IBAction)displayTeamPicker;
- (IBAction)displayPenaltyPicker;
- (IBAction)displayGamePicker;
- (IBAction)displayArenaPicker;
- (IBAction)displayCustomPicker;
- (IBAction)addToMessage;

// when we shutdown save our state
-(void)saveState;

@end
