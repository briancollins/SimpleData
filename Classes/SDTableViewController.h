//
//  SDTableViewController.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleStore.h"

@interface SDTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	SimpleStore *store;
}


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SimpleStore *store;

@end
