//
//  SimpleStoreTest.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-04.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "SimpleStoreTest.h"
#import "SimpleStore.h"
#import "Employee.h"
#import <Foundation/Foundation.h>

@implementation SimpleStoreTest

- (void)setUp {
    [SimpleStore storeWithPath:@"test.sqlite3"];
}

- (void)tearDown {
	[[SimpleStore currentStore] saveAndClose];
	[SimpleStore deleteStoreAtPath:@"test.sqlite3"];
}

- (void)testSetsCurrentStore {
	STAssertNotNULL([SimpleStore currentStore], @"Current store should exist");
	STAssertEquals([[[NSThread currentThread] threadDictionary] 
					objectForKey:SIMPLE_STORE_KEY], 
				   [SimpleStore currentStore], @"Current store should be stored in thread dictionary");
}

- (void)testCurrentStore {
	STAssertNotNULL([SimpleStore currentStore], @"Current store should exist");
}

- (void)testSaveAndClose {
	STAssertFalse([[SimpleStore currentStore] saveAndClose], @"saveAndClose should not work without changes");
	STAssertNotNULL([SimpleStore currentStore], @"CurrentStore should still exist");
}

- (void)testSaveAndCloseWithChanges {
	[Employee createWithName:@"Roger"];
	STAssertTrue([[SimpleStore currentStore] saveAndClose], @"saveAndClose should work with changes");
	STAssertNULL([SimpleStore currentStore], @"CurrentStore should not be defined");
	[SimpleStore storeWithPath:@"test.sqlite3"];
}

- (void)testCloseWithoutSave {
	[Employee createWithName:@"Jason"];
	[[SimpleStore currentStore] close];
	STAssertNULL([SimpleStore currentStore], @"CurrentStore should not be defined");
	[SimpleStore storeWithPath:@"test.sqlite3"];
	STAssertNULL([Employee findByName:@"Jason"], @"Unsaved record should not exist");
}




@end
