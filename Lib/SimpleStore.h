//
//  SimpleStore.h
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SimpleStore : NSObject {
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	NSString *path;
}

+ (id)storeWithPath:(NSString *)p;
+ (void)deleteStoreAtPath:(NSString *)p;
+ (id)currentStore;
- (id)initWithPath:(NSString *)p;
- (BOOL)save;
- (BOOL)close;
- (BOOL)saveAndClose;


@property (nonatomic, copy) NSString *path;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
