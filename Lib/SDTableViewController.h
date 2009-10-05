//
//  SDTableViewController.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "SimpleStore.h"

@interface SDTableViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	SimpleStore *store;
	NSString *modelName;
	NSString *sortBy;
}


@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SimpleStore *store;
@property (nonatomic, retain) NSString *modelName;
@property (nonatomic, retain) NSString *sortBy;

@end
