//
//  SimpleModelTest.m
//  SimpleData
//
//  Created by Brian Collins on 09-10-04.
//  Copyright 2009 Brian Collins. All rights reserved.
//

#import "SimpleStoreTest.h"
#import "SimpleStore.h"
#import "SDEmployee.h"
#import "SimpleModelTest.h"

#define DECEMBER_4TH [NSDate dateWithTimeIntervalSince1970:534103200]
#define JUNE_11TH    [NSDate dateWithTimeIntervalSince1970:929120400]

@implementation SimpleModelTest


- (void)setUp {
    [SimpleStore storeWithPath:@"test.sqlite3"];
	[SDEmployee createWithName:@"Quincey" dateOfBirth:DECEMBER_4TH starSign:@"Capricorn"];
	[SDEmployee createWithName:@"Alex" dateOfBirth:DECEMBER_4TH starSign:@"Aries"];
	[SDEmployee createWithName:@"Luna" dateOfBirth:DECEMBER_4TH starSign:@"Aries"];
	[SDEmployee createWithName:@"Luna" dateOfBirth:DECEMBER_4TH starSign:@"Sagittarius"];
}


- (void)tearDown {
	[[SimpleStore currentStore] saveAndClose];
	[SimpleStore deleteStoreAtPath:@"test.sqlite3"];
}


- (void)testCreateObject {
	SDEmployee *employee = [SDEmployee createWithName:@"Brian"];
	STAssertNotNULL(employee, @"Employee object should be created");
	STAssertEqualStrings(@"Brian", employee.name, @"Attribute should be set on creation");
}


- (void)testFindObject {
	SDEmployee *employee = [SDEmployee findByName:@"Alex"];
	STAssertNotNULL(employee, @"Employee should be found");
}


- (void)testFindByDate {
	SDEmployee *employee = [SDEmployee findByDateOfBirth:DECEMBER_4TH];
	STAssertNotNULL(employee, @"Employee should be found");	
}


- (void)testCantFindObject {
	SDEmployee *employee = [SDEmployee findByName:@"Jack"];
	STAssertNULL(employee, @"Non-existant employee should not be found");
}


- (void)testCantFindByDate {
	SDEmployee *employee = [SDEmployee findByDateOfBirth:JUNE_11TH];
	STAssertNULL(employee, @"Employee should not be found");	
}


- (void)testUpdateEmployee {
	SDEmployee *employee = [SDEmployee findByName:@"Alex"];
	employee.email = @"alex@example.com";
	
	STAssertTrue([employee save], @"The employee should be saved");
	STAssertNotNULL([SDEmployee findByEmail:@"alex@example.com"], @"The updated employee should be findable");
}


- (void)testFindAllBy {
	NSArray *employees = [SDEmployee findAllByDateOfBirth:DECEMBER_4TH];
	STAssertTrue([employees count] == 4, @"number of employees found should be 4");
}


- (void)testFindAllSortBy {
	NSArray *employees = [SDEmployee findAllByDateOfBirth:DECEMBER_4TH 
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
	NSArray *employees = [SDEmployee findAllByDateOfBirth:DECEMBER_4TH
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
	NSArray *employees = [SDEmployee findAllByDateOfBirth:DECEMBER_4TH
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
	Employee *employee = [SDEmployee createWithName:@"Brian" 
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
	Employee *employee = [SDEmployee createWithName:@"Gerrard"
										   smoker:[NSNumber numberWithBool:YES]];
	STAssertTrue([employee.smoker boolValue] == YES, @"Smoker attribute should be assigned on creation");
}


- (void)testFindOrCreateWithFindsExisting {
	Employee *employee = [SDEmployee createWithName:@"Alfie"
											email:@"alfie@example.com"];
	Employee *newEmployee = [SDEmployee findOrCreateWithEmail:@"alfie@example.com"
													   name:@"Alfie Jones"];
	STAssertEqualStrings(@"Alfie", [newEmployee name], 
						 @"findOrCreateWithEmail should return in case of existing employee");
	STAssertTrue([[SDEmployee findAllByEmail:@"alfie@example.com"] count] == 1,
				 @"Should not create a new employee if already exists");
	STAssertEqualStrings([[newEmployee.objectID URIRepresentation] absoluteString], 
						 [[employee.objectID URIRepresentation] absoluteString], 
						 @"Both employees should be the same");
}


- (void)testFindOrCreateWithCreatesNew {
	Employee *employee = [SDEmployee findOrCreateWithName:@"Patrick"];
	STAssertTrue([[SDEmployee findAllByName:employee.name] count] == 1,
				 @"Should create a new employee if none exists");
}

@end
