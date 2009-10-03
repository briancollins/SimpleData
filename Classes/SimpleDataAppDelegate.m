//
//  SimpleDataAppDelegate.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "SimpleDataAppDelegate.h"
#import "RootViewController.h"
#import "SimpleStore.h"

@implementation SimpleDataAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    	
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	rootViewController.store = [[SimpleStore alloc] initWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"/store.sqlite"]];

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	
}


- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

