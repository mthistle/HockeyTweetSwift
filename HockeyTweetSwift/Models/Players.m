//
//  Players.m
//  Call It Hockey
//
//  Created by Mark Thistle on 08/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Players.h"
#import "MTQueue.h"
#import "SynthesizeSingleton.h"
#import <JSON/JSON.h>

@interface Players (PrivateMethods)

// NSInvocationOperation selector to handle the web service request in a
// separate thread
-(void) pullLatestRosters;
-(NSArray *) sortRoster:(NSDictionary *)rDict;

-(NSString *) allocStringWithURL:(NSURL *)url;
- (id) objectWithUrl:(NSURL *)url;
- (NSDictionary *) retrievePlayerDict;

@end

@implementation Players

SYNTHESIZE_SINGLETON_FOR_CLASS(Players);

@synthesize playerDictionary;

-(id)init
{
	[super init];
	
	if (self != nil)
	{
		// TODO Retrieve MD5 hash
		// TODO Compare against stored MD5 hash
		NSString *path = [[NSString alloc] initWithFormat:@"%@/Library/Preferences/players.plist", NSHomeDirectory()];
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
		[path release];
		
		if (nil == dict)
		{
			// We do not have any cached data for the rosters so let's go retrieve some
			self.playerDictionary = [self retrievePlayerDict];
		}
		else
		{
			// We already have some cached data, so load that first
			self.playerDictionary = dict;
			// Kick off another thread to retrieve latest rosters using a NSOperation
			NSInvocationOperation *operation = 
			[[NSInvocationOperation alloc] initWithTarget:self
																					 selector:@selector(pullLatestRosters)
																						 object:nil];
			
			[[MTQueue sharedMTQueue] addOperation:operation];
			[operation release];
		}

		[dict release];		
	}
	return self;
}

-(void)saveState
{
  NSString *path = [[NSString alloc] initWithFormat:@"%@/Library/Preferences/players.plist", NSHomeDirectory()];
	[self.playerDictionary writeToFile:path atomically:YES];
	[path release];
}

-(NSArray*)getRosterForTeam:(NSString *)team
{
	NSDictionary* players = [self.playerDictionary objectForKey:@"players"];
	NSArray* sortedArray = [[players objectForKey:team]
													 sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];

	return sortedArray;
}

-(NSInteger)getSanitizedIndexWithIndex:(NSInteger)idx forArray:(NSArray *)array
{
	if ([array count] <= idx || idx < 0)
	{
		idx = 0;
	}
	return idx;
}

-(void) pullLatestRosters
{
	// TODO go get the latest rosters from the web service and rebuild the data
	NSLog(@"pullLatestRosters: NSinvocationOperation thread started!!");
	NSDictionary *tmpDict = [self retrievePlayerDict];
	if (nil != tmpDict && [tmpDict objectForKey:@"players"] != nil)
	{
	  self.playerDictionary = tmpDict;
	}
	else
	{
		NSLog(@"pullLatestRosters: Data integrity error in new player roster data; discarding");
	}
	NSLog(@"pullLatestRosters: NSInvocationOperation thread complete");
}

#pragma mark PrivateMethods

- (NSString *) allocStringWithUrl:(NSURL *)url
{
	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
	NSString *post;
	
	// retrieve the md5 string stored in the plist
	if (nil != self.playerDictionary)
	{
		post = [[NSString alloc] initWithFormat:@"md5=%@", [self.playerDictionary objectForKey:@"md5"]];
	}
	else
	{  // or use an empty one
		post = [[NSString alloc] initWithString:@"md5="];
	}
	
	NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
  NSString *postLength = [[NSString alloc] initWithFormat:@"%d", [postData length]];  
  
	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];  
	[urlRequest setURL:url]; 
	[urlRequest setHTTPMethod:@"POST"];  
	[urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[urlRequest setHTTPBody:postData];
	[urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
	[urlRequest setTimeoutInterval:10];
	
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
	
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
																	returningResponse:&response
																							error:&error];
	
	application.networkActivityIndicatorVisible = NO;
	[post release];
	[postLength release];
  [urlRequest release];
	
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (id) objectWithUrl:(NSURL *)url
{
	SBJSON *jsonParser = [SBJSON new];
	NSString *jsonString = [self allocStringWithUrl:url];
	// Parse the JSON into an Object
	id response = [jsonParser objectWithString:jsonString error:NULL];
	
	[jsonParser release];
	[jsonString release];
	
	return response;
}

- (NSDictionary *) retrievePlayerDict
{
	id response = [self objectWithUrl:[NSURL URLWithString:@"http://ref-it.appspot.com/players"]];
	//id response = [self objectWithUrl:[NSURL URLWithString:@"http://localhost:8080/players"]];
	
	NSDictionary *feed = (NSDictionary *)response;
	return feed;	
}

@end
