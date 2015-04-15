//
//  ComposeViewController.m
//  Call It Hockey
//
//  Created by Mark Thistle on 25/08/09.
//  Copyright 2009 __LockerNine.com__. All rights reserved.
//

#import "ComposeViewController.h"
#import "Teams.h"
#import "Players.h"
#import "Schedules.h"
#import "Penalties.h"
#import "FlipsideViewController.h"
#import "RoundedRect.h"
#import "CustomTemplates.h"

@implementation ComposeViewController

@synthesize tweetMsg, pickerView, navItem, pickerList, secondaryPickerList, pickerGames;
@synthesize lastSelectedGamePickerRow, lastSelectedTeamPickerRow, lastSelectedPlayerPickerRow, lastSelectedPenaltyPickerRow;
@synthesize lastSelectedArenaPickerRow, lastSelectedCustomPickerRow;
@synthesize infoButton;
@synthesize pickerArenas;
@synthesize charRemaining;
@synthesize myActivityIndicator, OAuthVC;

#pragma mark Threading Methods

- (void)loadGames
{
	Schedules *games = [Schedules sharedSchedules];
	
	self.pickerGames = [[NSMutableArray alloc] initWithArray:games.todayYesterdayTomorrowGames];
	self.lastSelectedGamePickerRow = games.firstGameForToday;
}

- (void)loadArenas
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Arenas" ofType:@"plist"];
	if (path)
	{
	  NSArray *tmpArray = [[NSArray alloc] initWithContentsOfFile:path];
		NSMutableArray *arenas = [[NSMutableArray alloc] init];
		for (NSDictionary *team in tmpArray)
		{
			[arenas addObject:[team objectForKey:@"Arena"]];
		}
		self.pickerArenas = arenas;
		[arenas release];
		[tmpArray release];
	}
	else
	{
		self.pickerArenas = [[NSArray alloc] initWithObjects:@"No arenas found.", nil];
	}
}

#pragma mark FlipsideView Methods

- (void)flipsideViewControllerDidFinish 
{	
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo 
{	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

#pragma mark UITextViewDelegate Methods

- (void)textViewDidChange:(UITextView *)textView
{
	int len = [self.tweetMsg.text length];

	if (self.tweetMsg.text != nil && [self.tweetMsg.text isEqualToString:@" "])
	{
		self.navItem.title = @"140";
		self.tweetMsg.text = @"";
	}
	else
	{
		NSString *newTitle = [[NSString alloc] initWithFormat:@"%d", 140 - len];
		self.navItem.title = newTitle;
		[newTitle release];
	}
	
	// let's help alert the user if the tweet is over 140 characters
	if ([self.tweetMsg.text length] > 140)
	{
		// Add our charsRemianing UILabel to the navItem views so we can override
		// the color of the title of the compose view
		self.charRemaining.textColor = [UIColor redColor];
		self.charRemaining.text = self.navItem.title;
		self.navItem.titleView = self.charRemaining;
	}
	else
	{
		// Add our charsRemianing UILabel to the navItem views so we can override
		// the color of the title of the compose view
		self.charRemaining.textColor = [UIColor whiteColor];
		self.charRemaining.text = self.navItem.title;
		self.navItem.titleView = self.charRemaining;
	}
}

#pragma mark Button Handler Methods

- (IBAction)sendMsg
{		
	NSLog(@"User choose to send message");
	
	if ([self.tweetMsg.text length] > 140)
	{
		UIAlertView *tweetTooLongAlert= [[UIAlertView alloc] 
																 initWithTitle:NSLocalizedString(
																   @"Message Too Long", 
																	 @"TweetTooLongAlertTitle") 
																 message:NSLocalizedString(
																	 @"Sorry a tweet can only be 140 characters or less, please shorten your tweet", 
																	 @"TweetTooLongAlertText")
																 delegate:nil
																 cancelButtonTitle:nil
																 otherButtonTitles:@"OK",
																 nil];
		
		[tweetTooLongAlert show];
		[tweetTooLongAlert release];
	}
	else
	{
		// First get a token for sending messages
		[[TwitterEngine sharedTwitterEngine].twitterEngine requestRequestToken];
		
		self.OAuthVC = 
	  [SA_OAuthTwitterController 
		 controllerToEnterCredentialsWithTwitterEngine:
		 [TwitterEngine sharedTwitterEngine].twitterEngine
		 delegate:[TwitterEngine sharedTwitterEngine]];
		
		if (self.OAuthVC)
		{
			[self presentModalViewController:self.OAuthVC animated:YES];
		}
		else
		{
			// Let's draw a nicer rounded rect view to put our results into
			self.myActivityIndicator = [[RoundedRect alloc] initWithFrame:CGRectMake(120.0, 75.0, 100.0, 100.0)];
			
			[self.view addSubview:self.myActivityIndicator];
			[self.myActivityIndicator startAnimating];
			
			[[TwitterEngine sharedTwitterEngine] sendMsg:self.tweetMsg.text from:self];
		}
	}
}

- (void)messageSendResult:(BOOL)sendSuccess
{
	// TODO stop the activity indicator and replace with X or Tick if it was
	// successful or failed, use wingdings for the X and tick
	[self.myActivityIndicator stopAnimatingWithSuccess:sendSuccess];
	[self.myActivityIndicator removeFromSuperview];
	[self.myActivityIndicator release];
	
	// Figure out the result of the send
	if (sendSuccess)
	{
		NSLog(@"Msg sent OK");
	  self.tweetMsg.text = @"";
	}
	else
	{
		// inform user and retry
		NSLog(@"Msg sent FAIL");
		UIAlertView *sendFailedAlert= [[UIAlertView alloc] 
																		 initWithTitle:NSLocalizedString(
																		@"Send Failed", @"SendFailedAlertTitle") 
																		 message:NSLocalizedString(
																		@"Sorry we had trouble sending your tweet, please try again or resend later.", @"SendFailedAlertText")
																		 delegate:nil
																		 cancelButtonTitle:nil
																		 otherButtonTitles:@"OK",
																		 nil];
		
		[sendFailedAlert show];
		[sendFailedAlert release];
	}
}

- (IBAction)cancelCompose
{
	NSLog(@"User choose to cancel composition of message");
  self.tweetMsg.text = @"";
	[self textViewDidChange:self.tweetMsg];
}

- (IBAction)displayGamePicker
{
	[self.tweetMsg resignFirstResponder];

	if (gamePickerSelected)
	{
		return;
	}
	else if (penaltyPickerSelected)
	{
		// First we need to cache the penalty that was selected so we can reload it
		// when we switch back
		self.lastSelectedPenaltyPickerRow = [self.pickerView selectedRowInComponent:0];
		
		// Now turn off the penaltyPicker since we are switching to the team picker
		penaltyPickerSelected = NO;
	}
	else if (arenaPickerSelected)
	{
		self.lastSelectedArenaPickerRow = [self.pickerView selectedRowInComponent:0];
		arenaPickerSelected = NO;
	}
	else if (customPickerSelected)
	{
		self.lastSelectedCustomPickerRow = [self.pickerView selectedRowInComponent:0];
		customPickerSelected = NO;
	}
	else
	{
		// First we need to cache the team and player that was selected so we can 
		// reload it when we switch back
		self.lastSelectedTeamPickerRow = [self.pickerView selectedRowInComponent:0];
		self.lastSelectedPlayerPickerRow = [self.pickerView selectedRowInComponent:1];
		
		teamPickerSelected = NO;
	}
	// Now turn on the game Picker since we are switching to the game picker
	gamePickerSelected = YES;
	
	NSLog(@"User choose to display the GamePicker");
  
	self.pickerList = self.pickerGames;
	
	[self.pickerView reloadAllComponents];
	[self.pickerView selectRow:self.lastSelectedGamePickerRow inComponent:0 animated:NO];
	if ([self.pickerList count] == 1)
	{
		self.lastSelectedGamePickerRow = 0;
	}
}

- (IBAction)displayTeamPicker
{
	[self.tweetMsg resignFirstResponder];

	if (teamPickerSelected)
	{
		return;
	}
	else if (gamePickerSelected)
	{
		// First we need to cache the game that was selected so we can reload it
		// when we switch back
		self.lastSelectedGamePickerRow = [self.pickerView selectedRowInComponent:0];
		// Now turn on the game Picker since we are switching to the game picker
		gamePickerSelected = NO;
	}
	else if (arenaPickerSelected)
	{
		self.lastSelectedArenaPickerRow = [self.pickerView selectedRowInComponent:0];
		arenaPickerSelected = NO;
	}
	else if (customPickerSelected)
	{
		self.lastSelectedCustomPickerRow = [self.pickerView selectedRowInComponent:0];
		customPickerSelected = NO;
	}
	else //if (penaltyPickerSelected)
	{
		// First we need to cache the penalty that was selected so we can reload it
		// when we switch back
		self.lastSelectedPenaltyPickerRow = [self.pickerView selectedRowInComponent:0];
		penaltyPickerSelected = NO;
	}
	
	teamPickerSelected = YES;
	
	NSLog(@"User choose to display the TeamPicker");
	Teams *teams = [Teams sharedTeams];
	self.pickerList = (NSMutableArray *) teams.teamTLA;
	[self.pickerView reloadComponent:0];
	
	[self.pickerView selectRow:self.lastSelectedTeamPickerRow inComponent:0 animated:NO];
	
	// setup the player names for the first team
	Players *players = [Players sharedPlayers];
	self.secondaryPickerList 
	= (NSMutableArray*)[players getRosterForTeam:[self.pickerList 
																								objectAtIndex:self.lastSelectedTeamPickerRow]];
	[self.pickerView reloadAllComponents];
	
	self.lastSelectedPlayerPickerRow
	= [players getSanitizedIndexWithIndex:self.lastSelectedPlayerPickerRow 
															 forArray:self.secondaryPickerList];
	[self.pickerView selectRow:self.lastSelectedPlayerPickerRow inComponent:1 animated:NO];
	[self.pickerView reloadAllComponents];
}

- (IBAction)displayPenaltyPicker
{
	[self.tweetMsg resignFirstResponder];

	if (penaltyPickerSelected)
	{
		return;
	}
	else if (gamePickerSelected)
	{
		// First we need to cache the game that was selected so we can reload it
		// when we switch back
		self.lastSelectedGamePickerRow = [self.pickerView selectedRowInComponent:0];
		
		// Now turn on the game Picker since we are switching to the game picker
		gamePickerSelected = NO;
	}
	else if (arenaPickerSelected)
	{
		self.lastSelectedArenaPickerRow = [self.pickerView selectedRowInComponent:0];
		arenaPickerSelected = NO;
	}
	else if (customPickerSelected)
	{
		self.lastSelectedCustomPickerRow = [self.pickerView selectedRowInComponent:0];
		customPickerSelected = NO;
	}
	else // teamPickerSelected
	{
		// First we need to cache the team and player that was selected so we can 
		// reload it when we switch back
		self.lastSelectedTeamPickerRow   = [self.pickerView selectedRowInComponent:0];
		self.lastSelectedPlayerPickerRow = [self.pickerView selectedRowInComponent:1];
		
		teamPickerSelected = NO;
  }
	// Now turn on the penaltyPicker since we are switching from the team picker
	penaltyPickerSelected = YES;
	
	NSLog(@"User choose to display the PenaltyPicker");
	Penalties *penalties = [Penalties sharedPenalties];
	self.pickerList = (NSMutableArray *) penalties.sortedPenaltyList;
	[self.pickerView reloadAllComponents];
	
	// And now reset the rows on the team/player picker
	[self.pickerView selectRow:self.lastSelectedPenaltyPickerRow inComponent:0 animated:NO];
}

- (IBAction)displayArenaPicker
{
	[self.tweetMsg resignFirstResponder];
	
	if (arenaPickerSelected)
	{
		return;
	}
	else if (penaltyPickerSelected)
	{
		self.lastSelectedPenaltyPickerRow = [self.pickerView selectedRowInComponent:0];
		penaltyPickerSelected = NO;
	}
	else if (gamePickerSelected)
	{
		// First we need to cache the game that was selected so we can reload it
		// when we switch back
		self.lastSelectedGamePickerRow = [self.pickerView selectedRowInComponent:0];
		
		// Now turn on the game Picker since we are switching to the game picker
		gamePickerSelected = NO;
	}
	else if (customPickerSelected)
	{
		self.lastSelectedCustomPickerRow = [self.pickerView selectedRowInComponent:0];
		customPickerSelected = NO;
	}
	else// if (teamPickerSelected)
	{
		// First we need to cache the team and player that was selected so we can 
		// reload it when we switch back
		self.lastSelectedTeamPickerRow   = [self.pickerView selectedRowInComponent:0];
		self.lastSelectedPlayerPickerRow = [self.pickerView selectedRowInComponent:1];
		
		teamPickerSelected = NO;
	}
	// Now turn on the arena picker since the user asked to switch to Arenas
	arenaPickerSelected = YES;
	
	NSLog(@"User choose to display the ArenaPicker");
	self.pickerList = (NSMutableArray *)self.pickerArenas;	
	
	[self.pickerView reloadAllComponents];
	
	// And now reset the rows on the team/player picker
	[self.pickerView selectRow:self.lastSelectedArenaPickerRow inComponent:0 animated:NO];
}

- (IBAction)displayCustomPicker
{
	[self.tweetMsg resignFirstResponder];
	
	if (customPickerSelected)
	{
		return;
	}
	else if (arenaPickerSelected)
	{
		self.lastSelectedArenaPickerRow = [self. pickerView selectedRowInComponent:0];
		arenaPickerSelected = NO;
	}
	else if (penaltyPickerSelected)
	{
		self.lastSelectedPenaltyPickerRow = [self.pickerView selectedRowInComponent:0];
		penaltyPickerSelected = NO;
	}
	else if (gamePickerSelected)
	{
		// First we need to cache the game that was selected so we can reload it
		// when we switch back
		self.lastSelectedGamePickerRow = [self.pickerView selectedRowInComponent:0];
		
		// Now turn on the game Picker since we are switching to the game picker
		gamePickerSelected = NO;
	}
	else// if (teamPickerSelected)
	{
		// First we need to cache the team and player that was selected so we can 
		// reload it when we switch back
		self.lastSelectedTeamPickerRow   = [self.pickerView selectedRowInComponent:0];
		self.lastSelectedPlayerPickerRow = [self.pickerView selectedRowInComponent:1];
		
		teamPickerSelected = NO;
	}
	// Now turn on the arena picker since the user asked to switch to Arenas
	customPickerSelected = YES;
	
	NSLog(@"User choose to display the CustomPicker");
	self.pickerList = [CustomTemplates sharedCustomTemplates].templates;	
	
	[self.pickerView reloadAllComponents];
	
	// And now reset the rows on the team/player picker
	[self.pickerView selectRow:self.lastSelectedCustomPickerRow inComponent:0 animated:NO];
}

- (IBAction)addToMessage
{
	NSString *newText = @"";

	if (penaltyPickerSelected)
	{	
	  newText = 
		  [[NSString alloc] initWithFormat:@"%@ ",
	     [self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
	}
	else if (customPickerSelected)
	{
		if (0 == [[CustomTemplates sharedCustomTemplates].templates count])
		{
			return; // nothing to see here
		}
				
    // TODO if this is the start of a string then capitalize the first char
		newText = 
			  [[NSString alloc] initWithFormat:@"%@", 
	       [self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
	}
	else if (arenaPickerSelected)
	{
		if ([[self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]] caseInsensitiveCompare:@"No arenas found."] == NSOrderedSame)
		{
			return; //nothing to see here, do not post
		}
		
		//TODO capitalize the first character of the string if textView.text is empty
		newText = 
				[[NSString alloc] initWithFormat:@"%@", 
	       [self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
	}
	else if (gamePickerSelected)
	{	
		if ([[self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]] caseInsensitiveCompare:@"No Games Today"] == NSOrderedSame)
		{
		  return; // nothing to see here do not post
		}
		
		int len = [self.tweetMsg.text length];
		if (0 == len)
		{
	    newText = 
			  [[NSString alloc] initWithFormat:@"NHL: %@ ",
		     [[self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]]
					stringByReplacingOccurrencesOfString:@" " withString:@""]];
		}
		else
		{
			newText = 
				[[NSString alloc] initWithFormat:@"%@",
	       [[self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]] 
					stringByReplacingOccurrencesOfString:@" "	withString:@""]];
		}
	}
	else
	{
		// now build the string to add to the tweet
		newText = 
				[[NSString alloc] initWithFormat:@"#%@-%@: ",
			   [self.pickerList objectAtIndex:[self.pickerView selectedRowInComponent:0]], 
	       [self.secondaryPickerList objectAtIndex:[self.pickerView selectedRowInComponent:1]]];
	}	
	
	if ([self.tweetMsg.text length] + [newText length] > 240)
	{
		NSLog(@"Shorten your text");
	}
	else
	{
	  self.tweetMsg.text = [self.tweetMsg.text stringByAppendingString:newText];
		// Alert ourself to the fact that the message changed so we can update the
		// title with the chars remaining and adjust any colors that we might be 
		// able to change
		[self textViewDidChange:self.tweetMsg];
	}
	
	[newText release];
}

-(void)configureInfoButton
{
	// setup the info button programmatically since this code is more reliable
	// when the user clicks it than the default with Interface Builder
	self.infoButton = [[UIButton buttonWithType:UIButtonTypeInfoDark] retain];
	CGRect infoFrame = [self.infoButton frame];
	infoFrame.origin.x = 285.0;
	infoFrame.origin.y = 425.0;
	[self.infoButton setFrame:infoFrame];
	[self.infoButton addTarget:self action:@selector(showInfo) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:self.infoButton];
}

-(void)firstRun
{
	NSString *destPath = [[NSString alloc] initWithFormat:@"%@/Library/Preferences/schedules.plist", NSHomeDirectory()];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
	if (![fileManager fileExistsAtPath:destPath])
	{
		NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"schedules" ofType:@"plist"];
		if (![fileManager copyItemAtPath:srcPath toPath:destPath error:&error])
		{
			NSLog(@"Failed to copy %@ to %@ with error \'%@\'", srcPath, destPath, [error description]);
		}
	}
	[destPath release];
	
	destPath = [[NSString alloc] initWithFormat:@"%@/Library/Preferences/players.plist", NSHomeDirectory()];
	if (![fileManager fileExistsAtPath:destPath])
	{
		NSString *srcPath = [[NSBundle mainBundle] pathForResource:@"players" ofType:@"plist"];
		if (![fileManager copyItemAtPath:srcPath toPath:destPath error:&error])
		{
			NSLog(@"Failed to copy %@ to %@ with error \'%@\'", srcPath, destPath, [error description]);
		}
	}

	[destPath release];		
}

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Lifecycle Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
	
	[self firstRun];
	
	[self configureInfoButton];	
	
	// let's initialize some stuff to default settings, specifically how ourn 
	// tweet compose picker is going to work.
	// TODO revisit this if we restart and things get reset incorreclty
  teamPickerSelected           = YES;
	penaltyPickerSelected        = NO;
	gamePickerSelected           = NO;
	arenaPickerSelected          = NO;
	customPickerSelected         = NO;
	self.lastSelectedPenaltyPickerRow = 0;
	self.lastSelectedTeamPickerRow    = 0;
	self.lastSelectedPlayerPickerRow  = 0;
	self.lastSelectedGamePickerRow    = 0;
	self.lastSelectedArenaPickerRow   = 0;
	self.lastSelectedCustomPickerRow  = 0;
	
	// Get previously saved preferences
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *tmpMsg = [prefs stringForKey:@"TweetMsg"];
	NSString *tmpActivePicker = [prefs stringForKey:@"CurrentUIPicker"];
	
	// Create a custom lable we can use to display white for tweet msg under
	// 140 char and red for over 140 char
	self.charRemaining = [[UILabel alloc] init];
	self.charRemaining.frame = CGRectMake(150,0,40,44);
	self.charRemaining.backgroundColor = [UIColor clearColor];
	self.charRemaining.font = [UIFont fontWithName:@"Helvetica" size:20];
	
	// Set the text in the UITextView
	if ([tmpMsg length] > 0)
	{
	  self.tweetMsg.text = [tmpMsg retain];
	}
	else
	{
	  self.tweetMsg.text = @"";
	}
	// after setting the tweetMsg UITextView string set the title
	[self textViewDidChange:self.tweetMsg];
	
	// Load the cached data
	self.lastSelectedPenaltyPickerRow = [prefs integerForKey:@"CurrentPenalty"];
	if (self.lastSelectedPenaltyPickerRow < 0)
	{
		self.lastSelectedPenaltyPickerRow = 0;
	}
	self.lastSelectedGamePickerRow = [prefs integerForKey:@"CurrentGame"];
	if (self.lastSelectedGamePickerRow < 0)
	{
		self.lastSelectedGamePickerRow = 0;
	}
	self.lastSelectedTeamPickerRow = [prefs integerForKey:@"CurrentTeam"];
	if (self.lastSelectedTeamPickerRow < 0)
	{
		self.lastSelectedTeamPickerRow = 0;
	}	
	self.lastSelectedPlayerPickerRow = [prefs integerForKey:@"CurrentPlayer"];
	if (self.lastSelectedPlayerPickerRow < 0)
	{
		self.lastSelectedPlayerPickerRow = 0;
	}
	self.lastSelectedArenaPickerRow = [prefs integerForKey:@"CurrentArena"];
	if (self.lastSelectedArenaPickerRow < 0)
	{
		self.lastSelectedArenaPickerRow = 0;
	}
	self.lastSelectedCustomPickerRow = [prefs integerForKey:@"CurrentCustom"];
	if (self.lastSelectedCustomPickerRow < 0)
	{
		self.lastSelectedCustomPickerRow = 0;
	}
	
	// Load the default picker data
	Teams *teams = [Teams sharedTeams];
	self.pickerList = (NSMutableArray *) teams.teamTLA;
	
	// Load the default team list
	self.secondaryPickerList = (NSMutableArray*)[[Players sharedPlayers] 
															getRosterForTeam:[self.pickerList 
																										objectAtIndex:self.lastSelectedTeamPickerRow]];
	self.lastSelectedPlayerPickerRow = [[Players sharedPlayers] 
																 getSanitizedIndexWithIndex:self.lastSelectedPlayerPickerRow
																 forArray:self.secondaryPickerList];

	// Load the schedules
	[self loadGames];
	// Load the arenas
	[self loadArenas];
	
	// load the active view
	if ([tmpActivePicker isEqualToString:@"Penalty"])
	{
		[self displayPenaltyPicker];
		[self.pickerView selectRow:self.lastSelectedPenaltyPickerRow inComponent:0 animated:NO];		
  }
	else if ([tmpActivePicker isEqualToString:@"Games"])
	{
		[self displayGamePicker];
		[self.pickerView selectRow:self.lastSelectedGamePickerRow inComponent:0 animated:NO];
	}
	else if ([tmpActivePicker isEqualToString:@"Arenas"])
	{
		[self displayArenaPicker];
		[self.pickerView selectRow:self.lastSelectedArenaPickerRow inComponent:0 animated:NO];
	}
	else if ([tmpActivePicker isEqualToString:@"Custom"])
	{
		[self displayCustomPicker];
		[self.pickerView selectRow:self.lastSelectedCustomPickerRow inComponent:0 animated:NO];
	}
	else
	{
		// By default we start with the team picker selected, set our rows now so
		// that we grab the correctly selected team and player rows when the last
		// loader picker was something other than the teams picker
		[self.pickerView selectRow:self.lastSelectedTeamPickerRow inComponent:0 animated:NO];
		[self.pickerView selectRow:self.lastSelectedPlayerPickerRow inComponent:1 animated:NO];
	}
	//else if ([tmpActivePicker isEqualToString:@"Teams"])
	[self.pickerView reloadAllComponents];
	
	// Setup our Twitter credentials
	NSString *tmpUsername = [prefs stringForKey:@"TwitterUsername"];
	NSString *tmpPassword = [prefs stringForKey:@"TwitterPassword"];
	
	if (nil != tmpUsername && [tmpUsername length] > 0 &&
			nil != tmpPassword && [tmpPassword length] > 0)
	{
		TwitterEngine *te = [TwitterEngine sharedTwitterEngine]; 
	  [te.twitterEngine setUsername:tmpUsername password:tmpPassword];
	}
}

// We call viewWillAppear so that we update the custom view if it is shown when
// returning from the settings flipside view since the user may have updated the
// entires in the custom list.
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
	
	NSLog(@"Danger Will Robinson - Low Memory Detected");
	
	// Release any cached data, images, etc that aren't in use.
	// TODO Check pickerview state
	// if on games, release players
	// else if on teams release games
	// else release games and players (we can reload later)
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.infoButton = nil;
}

-(void)saveState
{
	// Store the current tweet string
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setObject:self.tweetMsg.text forKey:@"TweetMsg"];
	
	// Store the current active UIPickerView
	if (penaltyPickerSelected)
	{
	  [prefs setObject:@"Penalty" forKey:@"CurrentUIPicker"];
	}
	else if (gamePickerSelected)
	{
	  [prefs setObject:@"Games" forKey:@"CurrentUIPicker"];
	}
	else if (arenaPickerSelected)
	{
		[prefs setObject:@"Arenas" forKey:@"CurrentUIPicker"];
	}
	else if (customPickerSelected)
	{
		[prefs setObject:@"Custom" forKey:@"CurrentUIPicker"];
	}
	else
	{
	  [prefs setObject:@"Teams" forKey:@"CurrentUIPicker"];
	}
	
	// now save the currently selected picker rows
	[prefs setInteger:self.lastSelectedPenaltyPickerRow forKey:@"CurrentPenalty"];
	[prefs setInteger:self.lastSelectedGamePickerRow forKey:@"CurrentGame"];
  [prefs setInteger:self.lastSelectedTeamPickerRow forKey:@"CurrentTeam"];
	[prefs setInteger:self.lastSelectedPlayerPickerRow forKey:@"CurrentPlayer"];
	[prefs setInteger:self.lastSelectedArenaPickerRow forKey:@"CurrentArena"];
	[prefs setInteger:self.lastSelectedCustomPickerRow forKey:@"CurrentCustom"];
	
	[prefs synchronize];
}

#pragma mark UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView 
{	
	if (penaltyPickerSelected || gamePickerSelected || 
			arenaPickerSelected   || customPickerSelected)
	{
	  return 1;
	}
	else
	{
		return 2;
	}
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component 
{
	int count = 0;
	if (penaltyPickerSelected || gamePickerSelected || 
			arenaPickerSelected   || customPickerSelected)
	{
		count = [self.pickerList count];
	}
	else
	{
		switch (component) {
			case (0):
				count = [self.pickerList count];
				break;
			case (1):
				count = [self.secondaryPickerList count];
				break;
		}
	}
	
	return count;
}

#pragma mark UIPickerViewDelegate Methods

- (CGFloat)pickerView:(UIPickerView *)pickerView
		widthForComponent:(NSInteger)component
{
	if (penaltyPickerSelected || gamePickerSelected || 
			arenaPickerSelected   || customPickerSelected)
	{
		return 300;
	}
	else
	{
		switch (component) {
			case (0):
				return 75;
				break;
			case (1):
				return 225;
				break;
			default:
				return 300;
				break;
		}
	}
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
	NSString *tmp = @"";
	if (penaltyPickerSelected || gamePickerSelected || 
			arenaPickerSelected   || customPickerSelected)
	{
		tmp = [self.pickerList objectAtIndex:row];
	}
	else
	{
		switch (component) {
			case (0):
				tmp = [self.pickerList objectAtIndex:row];
				break;
			case (1):
				tmp = [self.secondaryPickerList objectAtIndex:row];
				break;
		}
  }
	
	return tmp;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	if (penaltyPickerSelected) 
	{
	  NSLog(@"Selected Penalty: %@ - row %i", [self.pickerList objectAtIndex:row], row);
		self.lastSelectedPenaltyPickerRow = row;
  }
	else if (gamePickerSelected)
	{
		NSLog(@"Selected Game: %@ - row %i", [self.pickerList objectAtIndex:row], row);
		self.lastSelectedGamePickerRow = row;
	}
	else if (arenaPickerSelected)
	{
		self.lastSelectedArenaPickerRow = row;
	}
	else if (customPickerSelected)
	{
		self.lastSelectedCustomPickerRow = row;
	}
	else
	{			
		Players *players = [Players sharedPlayers];
		switch (component) {
			case (0):
				NSLog(@"Selected Team: %@ - row %i", [self.pickerList objectAtIndex:row], row);

				self.lastSelectedTeamPickerRow = row;
				
				// Fun stuff: when user changes the team change the list on the right
				//with the player names
				self.secondaryPickerList 
				= (NSMutableArray*)[players getRosterForTeam:
														[self.pickerList objectAtIndex:self.lastSelectedTeamPickerRow]];
				[self.pickerView reloadComponent:1];
				
				self.lastSelectedPlayerPickerRow 
				= [players getSanitizedIndexWithIndex:self.lastSelectedPlayerPickerRow
																		 forArray:self.secondaryPickerList];
								
				[self.pickerView selectRow:0 inComponent:1 animated:NO];
								
				break;
			case (1):
				self.secondaryPickerList 
				= (NSMutableArray*)[players getRosterForTeam:
														[self.pickerList objectAtIndex:
														 [self.pickerView selectedRowInComponent:0]]];
				[self.pickerView reloadComponent:1];
				self.lastSelectedPlayerPickerRow 
				= [players getSanitizedIndexWithIndex:row
																		 forArray:self.secondaryPickerList];
								
				[self.pickerView selectRow:self.lastSelectedPlayerPickerRow inComponent:1 animated:NO];

				break;
		}
	}
}

#pragma mark Memory Management Methods

- (void)dealloc 
{
	[self.tweetMsg release];
	[self.pickerView release];
	[self.navItem release];
	[self.charRemaining release];
	
	[self.pickerList release];
	[self.secondaryPickerList release];
	[self.pickerGames release];
	[self.pickerArenas release];
		
	[self.infoButton release];
	[self.myActivityIndicator release];
	[self.OAuthVC release];
	
	[super dealloc];
}


@end
