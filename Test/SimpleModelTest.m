//
//  SimpleModelTest.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-04.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "SimpleStoreTest.h"
#import "SimpleStore.h"
#import "Employee.h"
#import "SimpleModelTest.h"


@implementation SimpleModelTest

- (void)setUp {
    [SimpleStore storeWithPath:@"/tmp/test.sqlite3"];
	[Employee createWithName:@"Quincey" dateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 4th 1986"]];
	[Employee createWithName:@"Alex" dateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 4th 1986"]];
	[Employee createWithName:@"Luna" dateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 4th 1986"]];
}

- (void)tearDown {
	[[SimpleStore currentStore] saveAndClose];
	[[NSFileManager defaultManager] removeItemAtPath:@"/tmp/test.sqlite3" error:nil];
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

- (void)testFindByDate {
	Employee *employee = [Employee findByDateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 4th 1986"]];
	STAssertNotNULL(employee, @"Employee should be found");	
}

- (void)testCantFindObject {
	Employee *employee = [Employee findByName:@"Jack"];
	STAssertNULL(employee, @"Non-existant employee should not be found");
}

- (void)testCantFindByDate {
	Employee *employee = [Employee findByDateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 5th 1986"]];
	STAssertNULL(employee, @"Employee should not be found");	
}

- (void)testUpdateEmployee {
	Employee *employee = [Employee findByName:@"Alex"];
	employee.email = @"alex@example.com";
	
	STAssertTrue([employee save], @"The employee should be saved");
	STAssertNotNULL([Employee findByEmail:@"alex@example.com"], "The updated employee should be findable");
}

- (void)testFindAllBy {
	NSArray *employees = [Employee findAllByDateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 4th 1986"]];
	STAssertTrue([employees count] == 3, @"number of employees found should be 3");
}

- (void)testFindAllSortBy {
	NSArray *employees = [Employee findAllByDateOfBirth:[NSDate dateWithNaturalLanguageString:@"December 4th 1986"] sortBy:@"name"];
	STAssertTrue([employees count] == 3, @"number of employees found should be 3");
	Employee *lastEmployee = nil;
	for (Employee *e in employees) {
		if (lastEmployee) {
			STAssertTrue([lastEmployee.name compare:e.name] == NSOrderedAscending, @"results should be sorted by name");
		}
		lastEmployee = e;				 
	}
}

- (void)testCreateObjectWithMoreThan5Attributes {
	Employee *employee = [Employee createWithName:@"Brian" 
											email:@"brian@example.com" 
										 starSign:@"libra"
										createdAt:[NSDate date]
										updatedAt:[NSDate date]
										bloodType:@"O"
									favoriteColor:@"purple"];
	STAssertNotNULL(employee, @"Employee object should be created");
	STAssertEqualStrings(@"Brian", employee.name, @"Attribute should be set on creation");
	STAssertEqualStrings(@"brian@example.com", employee.email, @"Attribute should be set on creation");
	STAssertEqualStrings(@"O", employee.bloodType, @"Attribute should be set on creation");
}


@end
