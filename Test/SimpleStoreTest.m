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


- (void)testCreateObject {
    [SimpleStore storeWithPath:@"/tmp/test.sqlite3"];
	Employee *employee = [Employee createWithName:@"Brian"];
	STAssertNotNULL(employee, @"Employee object is created");
	STAssertEqualStrings(@"Brian", employee.name, @"Attribute is set on creation");
}

- (void)testFindObject {
	Employee *employee = [Employee findByName:@"Brian"];
	STAssertNotNULL(employee, @"Employee is found");
}




@end
