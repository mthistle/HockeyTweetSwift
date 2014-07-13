//
//  Players.h
//  Call It Hockey
//
//  Created by Mark Thistle on 08/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Players : NSObject {
	NSDictionary *playerDictionary;
}

@property (retain) NSDictionary *playerDictionary;

+(Players *) sharedPlayers;

// when we shutdown save our state
-(void)saveState;

// return the list of players for the current team along with the 
// lastSelectedPlayer in the player list which we change to 0 if the player
// selected is out of range for this team roster (due to an update to the 
// list after we download an updated team roster)
// Returns the NSArray sorted by player name
-(NSArray*)getRosterForTeam:(NSString *)team;

// Returns a sanitized index for the passed in array, if the index passed in is
// within bounds of the array then it is returned, else 0 is returned
-(NSInteger)getSanitizedIndexWithIndex:(NSInteger)idx forArray:(NSArray *)array;
@end
