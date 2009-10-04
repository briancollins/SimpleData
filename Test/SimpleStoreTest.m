//
//  SimpleStoreTest.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-04.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SimpleStoreTest.h"
#import "SimpleStore.h"
#import "Employee.h"

@implementation SimpleStoreTest

- (void)setUp {
    [SimpleStore storeWithPath:@"/tmp/test.sqlite3"];
	[Employee createWithName:@"Alex"];
}

- (void)testCreateObject {
	Employee *employee = [Employee createWithName:@"Brian"];
	STAssertNotNULL(employee, @"Employee object should be created");
	STAssertEqualStrings(@"Brian", employee.name, @"Attribute should be set on creation");
}

- (void)testFindObject {
	Employee *employee = [Employee findByName:@"Alex"];
	STAssertNotNULL(employee, @"Employee should be found");
}

- (void)testCantFindObject {
	Employee *employee = [Employee findByName:@"Jack"];
	STAssertNULL(employee, @"Non-existant employee should not be found");
}


@end
