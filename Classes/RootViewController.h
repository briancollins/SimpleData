//
//  RootViewController.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "SimpleStore.h"

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	SimpleStore *store;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SimpleStore *store;
@end
