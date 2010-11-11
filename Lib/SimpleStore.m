//
//  SimpleStore.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-03.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "SimpleStore.h"
#import "NSString.h"
#import "UIApplication.h"

@implementation SimpleStore
@synthesize path;
static NSString *savedPath;

+ (void)load {
	savedPath = nil;
}

+ (id)currentStore {
	id threadStore = [[[NSThread currentThread] threadDictionary] objectForKey:SIMPLE_STORE_KEY];
	if (threadStore == nil && savedPath != nil) {
		threadStore = [self storeWithPath:savedPath];
	}
	
	return threadStore;
}


+ (NSString *)storePath:(NSString *)p {
	if (![p hasSubstring:@"/"])
		return [[UIApplication documentsDirectory] stringByAppendingPathComponent:p];
	else 
		return p;
}


+ (id)storeWithPath:(NSString *)p {
	savedPath = p;
	id current = [[SimpleStore alloc] initWithPath:[self storePath:p]];
	[[[NSThread currentThread] threadDictionary] setObject:current forKey:SIMPLE_STORE_KEY];
	return current;
}


+ (void)deleteStoreAtPath:(NSString *)p {	
	[[NSFileManager defaultManager] removeItemAtPath:[self storePath:p] error:nil];
}


- (id)initWithPath:(NSString *)p {
	if (self = [super init]) {
		self.path = p;
	}
	return self;
}


- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
	
    return managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
	if (managedObjectModel != nil) {
		return managedObjectModel;
	}
	managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	return managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {	
	if (persistentStoreCoordinator != nil) {
		return persistentStoreCoordinator;
	}

	NSURL *storeUrl = [NSURL fileURLWithPath: self.path];

	NSError *error = nil;
	persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}    

	return persistentStoreCoordinator;
}

- (BOOL)save {
	return managedObjectContext && [managedObjectContext hasChanges] && [managedObjectContext save:nil];
}

- (BOOL)saveAndClose {
	return [self save] && [self close];
}

- (BOOL)close {
	[[[NSThread currentThread] threadDictionary] removeObjectForKey:SIMPLE_STORE_KEY];
	[self release];
	savedPath = nil;
	return YES;
}

- (void)dealloc {
	[managedObjectContext release];
	[managedObjectModel release];
	[persistentStoreCoordinator release];

	[super dealloc];
}



@end
