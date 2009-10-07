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

#define DECEMBER_4TH [NSDate dateWithTimeIntervalSince1970:534103200]
#define JUNE_11TH    [NSDate dateWithTimeIntervalSince1970:929120400]

@implementation SimpleModelTest


- (void)setUp {
    [SimpleStore storeWithPath:@"test.sqlite3"];
	[Employee createWithName:@"Quincey" dateOfBirth:DECEMBER_4TH starSign:@"Capricorn"];
	[Employee createWithName:@"Alex" dateOfBirth:DECEMBER_4TH starSign:@"Aries"];
	[Employee createWithName:@"Luna" dateOfBirth:DECEMBER_4TH starSign:@"Aries"];
	[Employee createWithName:@"Luna" dateOfBirth:DECEMBER_4TH starSign:@"Sagittarius"];
}


- (void)tearDown {
	[[SimpleStore currentStore] saveAndClose];
	[SimpleStore deleteStoreAtPath:@"test.sqlite3"];
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
	Employee *employee = [Employee findByDateOfBirth:DECEMBER_4TH];
	STAssertNotNULL(employee, @"Employee should be found");	
}


- (void)testCantFindObject {
	Employee *employee = [Employee findByName:@"Jack"];
	STAssertNULL(employee, @"Non-existant employee should not be found");
}


- (void)testCantFindByDate {
	Employee *employee = [Employee findByDateOfBirth:JUNE_11TH];
	STAssertNULL(employee, @"Employee should not be found");	
}


- (void)testUpdateEmployee {
	Employee *employee = [Employee findByName:@"Alex"];
	employee.email = @"alex@example.com";
	
	STAssertTrue([employee save], @"The employee should be saved");
	STAssertNotNULL([Employee findByEmail:@"alex@example.com"], @"The updated employee should be findable");
}


- (void)testFindAllBy {
	NSArray *employees = [Employee findAllByDateOfBirth:DECEMBER_4TH];
	STAssertTrue([employees count] == 4, @"number of employees found should be 4");
}


- (void)testFindAllSortBy {
	NSArray *employees = [Employee findAllByDateOfBirth:DECEMBER_4TH 
												 sortBy:@"name"];
	STAssertTrue([employees count] == 4, @"number of employees found should be 4");
	Employee *lastEmployee = nil;
	for (Employee *e in employees) {
		if (lastEmployee) {
			STAssertTrue([lastEmployee.name compare:e.name] == NSOrderedAscending ||
						 [lastEmployee.name compare:e.name] == NSOrderedSame
						 , @"results should be sorted by name");
		}
		lastEmployee = e;				 
	}
}


- (void)testFindAllSortDescending {
	NSArray *employees = [Employee findAllByDateOfBirth:DECEMBER_4TH
									   sortByDescending:@"name"];
	STAssertTrue([employees count] == 4, @"number of employees found should be 4");
	Employee *lastEmployee = nil;
	for (Employee *e in employees) {
		if (lastEmployee) {
			STAssertTrue([lastEmployee.name compare:e.name] == NSOrderedDescending ||
						 [lastEmployee.name compare:e.name] == NSOrderedSame, 
						 @"results should be in descending order by name");
		}
		lastEmployee = e;				 
	}
}


- (void)testFindAllMultiSort {
	NSArray *employees = [Employee findAllByDateOfBirth:DECEMBER_4TH
									   sortByDescending:@"name"
												 sortBy:@"starSign"];
	Employee *lastEmployee = nil;
	for (Employee *e in employees) {
		if (lastEmployee) {
			STAssertTrue([lastEmployee.name compare:e.name] == NSOrderedDescending ||
						 ([lastEmployee.name compare:e.name] == NSOrderedSame && 
							  [lastEmployee.starSign compare:e.starSign] == NSOrderedAscending ||
							  [lastEmployee.starSign compare:e.starSign] == NSOrderedSame), 
						 @"results should be in descending order by name and ascending by starSign");
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


- (void)testCreateObjectWithNonPointerAttributes {
	// currently they must be assigned as NSNumbers or NSValues
	Employee *employee = [Employee createWithName:@"Gerrard"
										   smoker:[NSNumber numberWithBool:YES]];
	STAssertTrue([employee.smoker boolValue] == YES, @"Smoker attribute should be assigned on creation");
}


- (void)testFindOrCreateWithFindsExisting {
	Employee *employee = [Employee createWithName:@"Alfie"
											email:@"alfie@example.com"];
	Employee *newEmployee = [Employee findOrCreateWithEmail:@"alfie@example.com"
													   name:@"Alfie Jones"];
	STAssertEqualStrings(@"Alfie", [newEmployee name], 
						 @"findOrCreateWithEmail should return in case of existing employee");
	STAssertTrue([[Employee findAllByEmail:@"alfie@example.com"] count] == 1,
				 @"Should not create a new employee if already exists");
	STAssertEqualStrings([[newEmployee.objectID URIRepresentation] absoluteString], 
						 [[employee.objectID URIRepresentation] absoluteString], 
						 @"Both employees should be the same");
}


- (void)testFindOrCreateWithCreatesNew {
	Employee *employee = [Employee findOrCreateWithName:@"Patrick"];
	STAssertTrue([[Employee findAllByName:employee.name] count] == 1,
				 @"Should create a new employee if none exists");
}

@end
