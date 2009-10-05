//
//  SimpleDataAppDelegate.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright Brian Collins 2009. All rights reserved.
//

#import "SimpleDataAppDelegate.h"
#import "RootViewController.h"
#import "SimpleStore.h"
#import "User.h"

@implementation SimpleDataAppDelegate

@synthesize window;
@synthesize navigationController;


- (void)applicationDidFinishLaunching:(UIApplication *)application { 
	SimpleStore *store = [SimpleStore storeWithPath:@"store.sqlite"];
	[User createWithName:@"Brian Collins" email:@"bricollins@gmail.com" createdAt:[NSDate date]];
	
	RootViewController *rootViewController = (RootViewController *)[navigationController topViewController];
	rootViewController.store = store;
	rootViewController.modelName = @"User";
	rootViewController.sortBy = @"name";
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	[[SimpleStore currentStore] save];
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

